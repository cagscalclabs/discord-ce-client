"""OIDC device authorization. Provider tokens never leave this process."""

import asyncio
import base64
from dataclasses import dataclass
import hashlib
import hmac
import json
import time
from urllib.parse import quote_plus

import aiohttp
import jwt

from config import https_url


DEVICE_GRANT = "urn:ietf:params:oauth:grant-type:device_code"


class AuthError(Exception):
    """A public error code, never a provider response or credential."""


@dataclass(frozen=True)
class Identity:
    issuer: str
    subject: str
    expires_at: float


class OIDCProvider:
    def __init__(self, config, http):
        self.config = config
        self.http = http
        self.metadata = {}

    async def request(self, method, url, **kwargs):
        if not https_url(url):
            raise AuthError("provider_configuration")
        try:
            async with self.http.request(method, url, allow_redirects=False, **kwargs) as response:
                body = bytearray()
                async for chunk in response.content.iter_chunked(16384):
                    body.extend(chunk)
                    if len(body) > 262144:
                        raise AuthError("provider_response")
                data = json.loads(body)
                if not isinstance(data, dict):
                    raise AuthError("provider_response")
                return response.status, data
        except (aiohttp.ClientError, asyncio.TimeoutError, ValueError, UnicodeError):
            raise AuthError("provider_unavailable") from None

    async def discover(self):
        issuer = self.config["issuer"]
        status, data = await self.request("GET", issuer.rstrip("/") + "/.well-known/openid-configuration")
        if status != 200 or data.get("issuer") != issuer:
            raise AuthError("provider_configuration")
        for field in ("device_authorization_endpoint", "token_endpoint", "jwks_uri"):
            if not isinstance(data.get(field), str) or not https_url(data[field]):
                raise AuthError("provider_configuration")
        if (DEVICE_GRANT not in data.get("grant_types_supported", [])
                or "RS256" not in data.get("id_token_signing_alg_values_supported", [])
                or self.config["token_endpoint_auth_method"] not in
                data.get("token_endpoint_auth_methods_supported", ["client_secret_basic"])):
            raise AuthError("provider_configuration")
        self.metadata = data

    async def post(self, endpoint, data):
        data = dict(data)
        data["client_id"] = self.config["client_id"]
        kwargs = {}
        method = self.config["token_endpoint_auth_method"]
        if method == "client_secret_basic":
            credentials = (quote_plus(self.config["client_id"]) + ":" +
                           quote_plus(self.config["client_secret"])).encode("ascii")
            kwargs["headers"] = {"Authorization": "Basic " + base64.b64encode(credentials).decode("ascii")}
        elif method == "client_secret_post":
            data["client_secret"] = self.config["client_secret"]
        return await self.request("POST", self.metadata[endpoint], data=data, **kwargs)

    async def start(self):
        status, data = await self.post("device_authorization_endpoint", {"scope": "openid"})
        if status != 200:
            raise AuthError("device_authorization_failed")
        for key in ("device_code", "user_code", "verification_uri"):
            if not isinstance(data.get(key), str) or not 1 <= len(data[key]) <= 1024:
                raise AuthError("provider_response")
        if not https_url(data["verification_uri"]):
            raise AuthError("provider_response")
        for key, default in (("expires_in", None), ("interval", 5)):
            value = data.get(key, default)
            if type(value) is not int or value <= 0:
                raise AuthError("provider_response")
            data[key] = value
        return data

    async def poll(self, device, deadline):
        interval = device["interval"]
        while time.monotonic() + interval < deadline:
            await asyncio.sleep(interval)
            try:
                status, data = await self.post("token_endpoint", {
                    "grant_type": DEVICE_GRANT, "device_code": device["device_code"]})
            except AuthError as exc:
                if str(exc) != "provider_unavailable":
                    raise
                interval *= 2
                continue
            if time.monotonic() >= deadline:
                break
            if status == 200 and "error" not in data:
                return await self.validate(data)
            error = data.get("error")
            if error == "authorization_pending":
                continue
            if error == "slow_down" or status == 429:
                interval += 5
                continue
            if error in {"access_denied", "expired_token"}:
                raise AuthError(error)
            raise AuthError("device_authorization_failed")
        raise AuthError("expired_token")

    async def validate(self, tokens):
        """Pin RS256, issuer and audience, and require OIDC identity claims."""
        try:
            token = tokens["id_token"]
            if not isinstance(token, str) or len(token) > 32768:
                raise ValueError
            header = jwt.get_unverified_header(token)
            if header.get("alg") != "RS256" or not isinstance(header.get("kid"), str):
                raise ValueError
            status, jwks = await self.request("GET", self.metadata["jwks_uri"])
            if status != 200 or not isinstance(jwks.get("keys"), list):
                raise ValueError
            keys = [key for key in jwks["keys"] if isinstance(key, dict)
                    and key.get("kid") == header["kid"] and key.get("kty") == "RSA"
                    and key.get("use", "sig") == "sig"
                    and key.get("alg", "RS256") == "RS256"
                    and "verify" in key.get("key_ops", ["verify"])]
            if len(keys) != 1:
                raise ValueError
            public = jwt.PyJWK.from_dict(keys[0], algorithm="RS256").key
            if public.key_size < 2048:
                raise ValueError
            claims = jwt.decode(token, public, algorithms=["RS256"],
                                issuer=self.config["issuer"], audience=self.config["client_id"],
                                options={"require": ["iss", "sub", "aud", "exp", "iat"]})
            if type(claims["exp"]) is not int or type(claims["iat"]) is not int:
                raise ValueError
            if not isinstance(claims["sub"], str) or not 1 <= len(claims["sub"]) <= 255:
                raise ValueError
            audience = claims["aud"]
            if ((isinstance(audience, list) and len(audience) > 1) or "azp" in claims):
                if claims.get("azp") != self.config["client_id"]:
                    raise ValueError
            if "at_hash" in claims:
                digest = hashlib.sha256(tokens["access_token"].encode("ascii")).digest()[:16]
                expected = base64.urlsafe_b64encode(digest).rstrip(b"=").decode("ascii")
                if not hmac.compare_digest(expected, claims["at_hash"]):
                    raise ValueError
            return Identity(claims["iss"], claims["sub"], float(claims["exp"]))
        except (KeyError, TypeError, ValueError, OverflowError, jwt.PyJWTError):
            raise AuthError("invalid_identity_token") from None
