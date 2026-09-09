import json
import time
import unittest
from unittest.mock import AsyncMock, patch

from cryptography.hazmat.primitives.asymmetric import rsa
import jwt

from oidc import AuthError, DEVICE_GRANT, Identity, OIDCProvider


class OIDCTests(unittest.IsolatedAsyncioTestCase):
    @classmethod
    def setUpClass(cls):
        cls.key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        cls.other_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        cls.jwk = json.loads(jwt.algorithms.RSAAlgorithm.to_jwk(cls.key.public_key()))
        cls.jwk.update(kid="test-key", alg="RS256", use="sig")

    def setUp(self):
        self.provider = OIDCProvider({"issuer": "https://identity.example", "client_id": "calculator",
                                      "client_secret": "", "token_endpoint_auth_method": "none"}, None)
        self.provider.metadata = {"jwks_uri": "https://identity.example/keys"}
        self.provider.request = AsyncMock(return_value=(200, {"keys": [self.jwk]}))

    def token(self, changes=None, key=None):
        now = int(time.time())
        claims = {"iss": "https://identity.example", "sub": "alice", "aud": "calculator",
                  "iat": now, "exp": now + 3600}
        claims.update(changes or {})
        return jwt.encode(claims, key or self.key, algorithm="RS256", headers={"kid": "test-key"})

    async def test_valid_identity(self):
        identity = await self.provider.validate({"id_token": self.token()})
        self.assertEqual(identity.subject, "alice")
        self.assertEqual(identity.issuer, "https://identity.example")

    async def test_wrong_signature_claims_and_authorized_party_rejected(self):
        for changes in ({"iss": "https://attacker.example"}, {"aud": "other"},
                        {"exp": int(time.time()) - 1}, {"iat": int(time.time()) + 120},
                        {"sub": ""}, {"aud": ["calculator", "other"]}, {"azp": "other"},
                        {"at_hash": "wrong"}):
            with self.subTest(changes=changes), self.assertRaises(AuthError):
                await self.provider.validate({"id_token": self.token(changes), "access_token": "test"})
        with self.assertRaises(AuthError):
            await self.provider.validate({"id_token": self.token(key=self.other_key)})
        with self.assertRaises(AuthError):
            await self.provider.validate({"access_token": "no-id-token"})

    async def test_algorithm_confusion_rejected(self):
        token = jwt.encode({"sub": "alice"}, "a-long-test-secret-only-used-for-tests", algorithm="HS256",
                           headers={"kid": "test-key"})
        with self.assertRaises(AuthError):
            await self.provider.validate({"id_token": token})

    async def test_poll_pending_and_slow_down(self):
        self.provider.post = AsyncMock(side_effect=[(400, {"error": "authorization_pending"}),
                                                    (400, {"error": "slow_down"}),
                                                    (200, {"id_token": "test"})])
        expected = Identity("issuer", "subject", time.time() + 60)
        self.provider.validate = AsyncMock(return_value=expected)
        with patch("oidc.asyncio.sleep", new_callable=AsyncMock) as sleep:
            result = await self.provider.poll({"device_code": "private", "interval": 5}, time.monotonic() + 60)
        self.assertEqual(result, expected)
        self.assertEqual([call.args[0] for call in sleep.await_args_list], [5, 5, 10])

    async def test_poll_denied_expired_and_cancelled(self):
        for error in ("access_denied", "expired_token", "invalid_client"):
            self.provider.post = AsyncMock(return_value=(400, {"error": error}))
            with patch("oidc.asyncio.sleep", new_callable=AsyncMock), self.assertRaises(AuthError):
                await self.provider.poll({"device_code": "private", "interval": 5}, time.monotonic() + 60)
        self.provider.post.reset_mock()
        with self.assertRaises(AuthError):
            await self.provider.poll({"device_code": "private", "interval": 5}, time.monotonic() - 1)
        self.provider.post.assert_not_called()

    async def test_discovery_rejects_insecure_endpoint_or_wrong_issuer(self):
        data = {"issuer": "https://identity.example", "device_authorization_endpoint": "https://identity.example/device",
                "token_endpoint": "https://identity.example/token", "jwks_uri": "https://identity.example/keys",
                "grant_types_supported": [DEVICE_GRANT], "id_token_signing_alg_values_supported": ["RS256"],
                "token_endpoint_auth_methods_supported": ["none"]}
        self.provider.request = AsyncMock(return_value=(200, data))
        await self.provider.discover()
        for override in ({"issuer": "https://other.example"}, {"token_endpoint": "http://identity.example/token"}):
            self.provider.request = AsyncMock(return_value=(200, {**data, **override}))
            with self.assertRaises(AuthError):
                await self.provider.discover()

    async def test_client_auth_methods(self):
        self.provider.metadata["token_endpoint"] = "https://identity.example/token"
        for method in ("none", "client_secret_basic", "client_secret_post"):
            self.provider.config.update(token_endpoint_auth_method=method, client_secret="private")
            await self.provider.post("token_endpoint", {"grant_type": DEVICE_GRANT})
            kwargs = self.provider.request.call_args.kwargs
            self.assertEqual("headers" in kwargs, method == "client_secret_basic")
            self.assertEqual("client_secret" in kwargs["data"], method == "client_secret_post")


if __name__ == "__main__":
    unittest.main()
