import json
from pathlib import Path
import tempfile
import unittest

from config import ConfigError, load_config


class ConfigTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.path = Path(self.directory.name).resolve() / "host.json"

    def write_config(self, data):
        self.path.write_text(json.dumps(data), encoding="utf-8")

    def test_host_config_and_environment_precedence(self):
        self.write_config({"DISCORD_TOKEN": "file-secret", "RELAY_PORT": 9000,
                           "RELAY_CERT": "certs/server.pem"})
        result = load_config(self.path, {"DISCORD_TOKEN": "env-secret"})
        self.assertEqual(result["DISCORD_TOKEN"], "env-secret")
        self.assertEqual(result["RELAY_PORT"], 9000)
        self.assertEqual(Path(result["RELAY_CERT"]), self.path.parent / "certs/server.pem")
        self.assertEqual(Path(result["DATABASE_FILE"]), self.path.parent / "relay.sqlite3")

    def test_environment_selects_config_and_preserves_environment_paths(self):
        self.write_config({})
        result = load_config(environ={"RELAY_CONFIG": str(self.path),
                                      "RELAY_KEY": "relative.pem"})
        self.assertEqual(result["RELAY_KEY"], "relative.pem")

    def test_missing_explicit_file_fails(self):
        with self.assertRaises(ConfigError):
            load_config(self.path, {})

    def test_invalid_settings_fail_without_echoing_values(self):
        for data in ([], {"unknown": "secret"}, {"RELAY_PORT": "secret"},
                     {"RELAY_PORT": True}, {"RELAY_PORT": 65536},
                     {"SESSION_TTL": -1}, {"DISCORD_TOKEN": 123},
                     {"RELAY_KEY": ""}, {"oidc": {"client_secret": 123}},
                     {"DISCORD_DISPLAY_FMT": "{user.secret}"}):
            with self.subTest(data=data):
                self.write_config(data)
                with self.assertRaises(ConfigError) as caught:
                    load_config(self.path, {})
                self.assertNotIn("secret", str(caught.exception))

    def test_bad_json_does_not_echo_secret(self):
        self.path.write_text('{"DISCORD_TOKEN": "secret", broken}', encoding="utf-8")
        with self.assertRaises(ConfigError) as caught:
            load_config(self.path, {})
        self.assertNotIn("secret", str(caught.exception))

    def test_example_loads(self):
        result = load_config(Path(__file__).with_name("config.json.example"), {})
        self.assertEqual(result["oidc"]["issuer"], "https://account.ceagle.cc")
        self.assertEqual(result["DISCORD_TOKEN"], "")


if __name__ == "__main__":
    unittest.main()
