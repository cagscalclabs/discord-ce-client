"""Host configuration for the relay; no network or Discord dependency."""

import json
import os
from pathlib import Path
from string import Formatter
from urllib.parse import urlsplit


DEFAULTS = {
    "DISCORD_TOKEN": "",
    "PERMISSIONS": 68608,  # View Channels, Send Messages, Read Message History.
    "RELAY_HOST": "0.0.0.0",
    "RELAY_PORT": 8443,
    "RELAY_CERT": "relay_cert.pem",
    "RELAY_KEY": "relay_key.pem",
    "DATABASE_FILE": "relay.sqlite3",
    "DISCORD_DISPLAY_FMT": "[{user}] {text}",
    "SESSION_TTL": 3600,
    "LOGIN_TIMEOUT": 600,
    "MAX_CLIENTS": 64,
    "MAX_CLIENTS_PER_IP": 4,
    "MAX_SESSIONS": 1024,
    "SEND_INTERVAL": 2,
}

OIDC_FIELDS = {"issuer", "client_id", "client_secret", "token_endpoint_auth_method"}
OIDC_DEFAULTS = {"issuer": "https://account.ceagle.cc", "client_id": "",
                 "client_secret": "", "token_endpoint_auth_method": "none"}
INTEGER_RANGES = {"RELAY_PORT": (1, 65535), "SESSION_TTL": (60, 86400),
                  "LOGIN_TIMEOUT": (60, 1800), "MAX_CLIENTS": (1, 10000),
                  "MAX_CLIENTS_PER_IP": (1, 100), "SEND_INTERVAL": (1, 60)}
INTEGER_RANGES["MAX_SESSIONS"] = (1, 100000)
INTEGER_RANGES["PERMISSIONS"] = (0, 2**64 - 1)


def https_url(value):
    try:
        parsed = urlsplit(value)
        return (parsed.scheme == "https" and bool(parsed.hostname)
                and not parsed.username and not parsed.password and not parsed.fragment)
    except ValueError:
        return False


class ConfigError(ValueError):
    """Configuration errors that are safe to display without secret values."""


def load_config(path=None, environ=None):
    """Environment overrides file values; file-relative paths ignore launch cwd.

    A missing default file preserves legacy environment-only operation. An
    explicitly selected file must exist.
    """
    env = os.environ if environ is None else environ
    selected = path if path is not None else env.get("RELAY_CONFIG")
    config_path = Path(selected) if selected is not None else Path(__file__).with_name("config.json")
    try:
        with config_path.open(encoding="utf-8") as source:
            data = json.load(source)
    except FileNotFoundError:
        if selected is not None:
            raise ConfigError("Selected relay configuration file does not exist.") from None
        data = {}
    except (OSError, UnicodeError, ValueError):
        raise ConfigError("Cannot read relay configuration as valid UTF-8 JSON.") from None

    if not isinstance(data, dict):
        raise ConfigError("Relay configuration must be a JSON object.")
    if set(data) - (set(DEFAULTS) | {"oidc"}):
        raise ConfigError("Relay configuration contains unknown settings.")
    oidc = data.get("oidc", {})
    if not isinstance(oidc, dict) or set(oidc) - OIDC_FIELDS:
        raise ConfigError("oidc must be an object containing supported settings.")
    if any(not isinstance(value, str) for value in oidc.values()):
        raise ConfigError("oidc settings must be strings.")
    oidc = {key: env.get("OIDC_" + key.upper(), oidc.get(key, default))
            for key, default in OIDC_DEFAULTS.items()}
    if not https_url(oidc["issuer"]) or urlsplit(oidc["issuer"]).query:
        raise ConfigError("oidc.issuer must be an HTTPS issuer URL without query or fragment.")
    if oidc["token_endpoint_auth_method"] not in {"none", "client_secret_basic", "client_secret_post"}:
        raise ConfigError("Unsupported OIDC token endpoint authentication method.")

    result = {}
    for key, default in DEFAULTS.items():
        value = env.get(key.upper(), data.get(key, default))
        if key in INTEGER_RANGES:
            if isinstance(value, bool) or not isinstance(value, (int, str)):
                raise ConfigError(f"{key} must be an integer.")
            try:
                value = int(value)
            except ValueError:
                raise ConfigError(f"{key} must be an integer.") from None
            low, high = INTEGER_RANGES[key]
            if not low <= value <= high:
                raise ConfigError(f"{key} is outside its allowed range.")
        elif not isinstance(value, str):
            raise ConfigError(f"{key} must be a string.")
        elif not value.strip() and key != "DISCORD_TOKEN":
            raise ConfigError(f"{key} must not be empty.")
        result[key] = value

    try:
        fields = list(Formatter().parse(result["DISCORD_DISPLAY_FMT"]))
        if any(field not in (None, "user", "text") or spec or conversion
               for _, field, spec, conversion in fields):
            raise ValueError
        if not {"user", "text"} <= {field for _, field, _, _ in fields}:
            raise ValueError
        if len(result["DISCORD_DISPLAY_FMT"]) > 200:
            raise ValueError
    except ValueError:
        raise ConfigError("DISCORD_DISPLAY_FMT requires {user} and {text}, no other placeholders, and at most 200 characters.") from None

    for key in ("RELAY_CERT", "RELAY_KEY", "DATABASE_FILE"):
        value = Path(result[key]).expanduser()
        # Preserve cwd-relative paths explicitly supplied through legacy env vars.
        if key not in env and not value.is_absolute():
            value = config_path.resolve().parent / value
        result[key] = str(value)
    result["oidc"] = dict(oidc)
    return result


def validate_runtime(config):
    if not config["DISCORD_TOKEN"].strip():
        raise ConfigError("DISCORD_TOKEN is required.")
    if not config["oidc"]["client_id"].strip():
        raise ConfigError("oidc.client_id is required.")
    oidc = config["oidc"]
    if oidc["token_endpoint_auth_method"] != "none" and not oidc["client_secret"]:
        raise ConfigError("The selected OIDC authentication method requires a client secret.")
