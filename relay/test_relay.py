import asyncio
import datetime
import ipaddress
import json
from pathlib import Path
import tempfile
import ssl
import time
from types import SimpleNamespace
import unittest
from unittest.mock import AsyncMock, Mock

import discord
from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.x509.oid import NameOID

from config import load_config
from oidc import Identity
from relay import CalcClient, DiscordBridge, LinkStore, RelayError, RelayServer, parse_request


def events(client):
    result = []
    while not client.outgoing.empty():
        result.append(json.loads(client.outgoing.get_nowait()))
    return result


def client():
    writer = Mock()
    writer.get_extra_info.return_value = ("127.0.0.1", 1)
    return CalcClient(asyncio.StreamReader(), writer, 600)


class RelayTests(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.store = LinkStore(str(Path(self.directory.name) / "links.sqlite3"))
        self.addCleanup(self.store.close)
        self.config = load_config(Path(__file__).with_name("config.json.example"), {})
        self.provider = Mock()
        self.relay = RelayServer(self.config, self.provider, self.store)
        self.bridge = DiscordBridge(self.relay)
        self.addAsyncCleanup(self.bridge.close)
        self.bridge.is_ready = Mock(return_value=True)
        self.identity = Identity("https://identity.example", "alice", time.time() + 600)
        self.store.add(self.identity, 101)
        self.client = client()
        self.relay.clients.add(self.client)
        await self.relay.authenticate(self.client, self.identity, 101, "login")
        self.token = events(self.client)[0]["token"]
        self.member = Mock(id=101, display_name="Alice")
        self.member.is_timed_out.return_value = False
        self.bot = Mock(id=999)
        self.bot.is_timed_out.return_value = False
        self.guild = Mock(id=1, name="Guild", unavailable=False, me=self.bot)
        self.guild.get_member.side_effect = lambda uid: self.member if uid == 101 else None
        self.channel = Mock(spec=discord.TextChannel)
        self.channel.id, self.channel.guild = 11, self.guild
        self.channel.name, self.channel.position, self.channel.slowmode_delay = "general", 0, 0
        self.user_perms = discord.Permissions(view_channel=True, send_messages=True, read_message_history=True)
        self.bot_perms = discord.Permissions(view_channel=True, send_messages=True, read_message_history=True)
        self.channel.permissions_for.side_effect = lambda actor: self.bot_perms if actor is self.bot else self.user_perms
        self.guild.get_channel.side_effect = lambda cid: self.channel if cid == 11 else None
        self.guild.text_channels = [self.channel]
        self.bridge.get_guild = Mock(side_effect=lambda gid: self.guild if gid == 1 else None)

    async def select(self):
        await self.relay.dispatch(self.client, {"op": "select_guild", "id": "g", "guild_id": "1"})
        await self.relay.dispatch(self.client, {"op": "select_channel", "id": "c", "channel_id": "11"})
        events(self.client)

    async def test_session_replacement_rotation_and_logout(self):
        newer = client()
        self.relay.clients.add(newer)
        await self.relay.dispatch(newer, {"op": "resume", "id": "r", "token": self.token})
        self.assertTrue(self.client.closed)
        rotated = events(newer)[0]["token"]
        self.assertNotEqual(rotated, self.token)
        with self.assertRaises(RelayError):
            await self.relay.dispatch(client(), {"op": "resume", "id": "x", "token": self.token})
        await self.relay.dispatch(newer, {"op": "logout", "id": "out"})
        with self.assertRaises(RelayError):
            await self.relay.dispatch(client(), {"op": "resume", "id": "x", "token": rotated})

    async def test_link_requires_live_code_and_calculator_confirmation(self):
        pending = client()
        pending.identity = Identity("issuer", "bob", time.time() + 60)
        pending.link_code = "1234567890ABCDEF"
        self.relay.clients.add(pending)
        self.assertFalse(await self.relay.claim_link("WRONG", 202, "Bob"))
        self.assertTrue(await self.relay.claim_link(pending.link_code, 202, "Bob"))
        self.assertIsNone(self.store.lookup(pending.identity))
        self.assertFalse(await self.relay.claim_link("1234567890ABCDEF", 303, "Other"))
        with self.assertRaises(RelayError):
            await self.relay.dispatch(pending, {"op": "link_confirm", "id": "x", "discord_id": "303"})
        identity = pending.identity
        await self.relay.dispatch(pending, {"op": "link_confirm", "id": "x", "discord_id": "202"})
        self.assertEqual(self.store.lookup(identity), 202)
        await self.relay.unlink(202)
        self.assertIsNone(self.store.lookup(identity))
        self.assertTrue(pending.closed)

    async def test_link_uniqueness_and_persistence(self):
        with self.assertRaises(RelayError):
            self.store.add(Identity("issuer", "other", 100), 101)
        another = LinkStore(str(Path(self.directory.name) / "links.sqlite3"))
        try:
            self.assertEqual(another.lookup(self.identity), 101)
        finally:
            another.close()

    async def test_cross_server_and_private_channel_denied(self):
        await self.select()
        for operation in ({"op": "select_guild", "guild_id": "2"},
                          {"op": "select_channel", "channel_id": "22"}):
            with self.assertRaises(RelayError):
                await self.relay.dispatch(self.client, {"id": "x", **operation})
        self.user_perms.view_channel = False
        self.assertEqual(self.bridge.visible_channels(self.client), [])
        with self.assertRaises(RelayError):
            await self.relay.dispatch(self.client, {"op": "send", "id": "s", "text": "secret"})
        self.channel.send.assert_not_called()

    async def test_live_permissions_expiry_and_reset(self):
        await self.select()
        fields = {"guild_id": "1", "channel_id": "11", "message_id": "100", "text": "hello"}
        await self.relay.publish("message", 1, 11, **fields)
        self.assertEqual(events(self.client)[0]["type"], "message")
        await self.relay.publish("message", 2, 11, **fields)
        self.assertEqual(events(self.client), [])
        # A permission loss also removes content still waiting in the output queue.
        await self.relay.publish("message", 1, 11, **fields)
        self.user_perms.view_channel = False
        await self.relay.revalidate(1)
        self.assertEqual([event["type"] for event in events(self.client)], ["reset"])
        self.assertIsNone(self.client.guild_id)
        self.user_perms.view_channel = True
        await self.select()
        self.client.session.expires_at = time.time() - 1
        await self.relay.publish("message", 1, 11, **fields)
        self.assertEqual(events(self.client)[0]["type"], "reset")

    async def test_send_ack_mentions_rate_limit_and_failure(self):
        await self.select()
        self.channel.send = AsyncMock(return_value=SimpleNamespace(id=100))
        await self.relay.dispatch(self.client, {"op": "send", "id": "s", "text": "hello @everyone"})
        self.assertEqual(events(self.client)[0]["type"], "sent")
        self.assertFalse(self.channel.send.call_args.kwargs["allowed_mentions"].everyone)
        self.assertIn("Alice", self.channel.send.call_args.args[0])
        with self.assertRaises(RelayError):
            await self.relay.dispatch(self.client, {"op": "send", "id": "s2", "text": "again"})
        self.relay.send_cooldowns.clear()
        self.channel.send.side_effect = discord.Forbidden(SimpleNamespace(status=403, reason="Forbidden"), "denied")
        with self.assertRaises(discord.Forbidden):
            await self.relay.dispatch(self.client, {"op": "send", "id": "s3", "text": "no"})
        self.assertEqual(events(self.client), [])

    async def test_bot_permissions_timeout_and_history_are_distinct(self):
        await self.select()
        self.bot_perms.send_messages = False
        with self.assertRaises(RelayError):
            self.bridge.access(self.client, 11, send=True)
        self.assertIs(self.bridge.access(self.client, 11), self.channel)
        self.user_perms.read_message_history = False
        with self.assertRaises(RelayError):
            await self.relay.dispatch(self.client, {"op": "history", "id": "h"})
        self.bot_perms.send_messages = True
        self.member.is_timed_out.return_value = True
        with self.assertRaises(RelayError):
            self.bridge.access(self.client, 11, send=True)

    async def test_history_rechecks_permissions_after_fetch(self):
        await self.select()

        async def history(**kwargs):
            self.user_perms.view_channel = False
            if False:
                yield None

        self.channel.history = history
        with self.assertRaises(RelayError):
            await self.relay.dispatch(self.client, {"op": "history", "id": "h"})
        self.assertEqual(events(self.client), [])

    async def test_bounded_pages_keep_duplicate_names_with_distinct_ids(self):
        rows = [{"channel_id": str(i), "name": "general"} for i in range(30)]
        await self.relay.page(self.client, {"id": "p"}, "channel", rows)
        result = events(self.client)
        self.assertEqual(len(result), 26)
        self.assertEqual(result[-1]["next_offset"], 24)
        self.assertEqual(len({row["channel_id"] for row in result[1:-1]}), 24)

    async def test_message_text_cannot_inject_frames_and_output_is_bounded(self):
        await self.client.emit("message", text='hello\n{"type":"authenticated"}')
        raw = self.client.outgoing.get_nowait()
        self.assertEqual(raw.count(b"\n"), 1)
        self.assertEqual(json.loads(raw)["type"], "message")
        for _ in range(65):
            await self.client.emit("pong")
        self.assertTrue(self.client.closed)

    async def test_gateway_handlers_emit_without_duplicate_argument_errors(self):
        await self.select()
        message = SimpleNamespace(guild=self.guild, channel=self.channel, id=555,
                                  author=self.member, content="hello", attachments=[])
        await self.bridge.on_message(message)
        self.assertEqual(events(self.client)[0]["message_id"], "555")
        payload = SimpleNamespace(guild_id=1, channel_id=11, message_id=555)
        await self.bridge.on_raw_message_edit(payload)
        await self.bridge.on_raw_message_delete(payload)
        self.assertEqual([event["type"] for event in events(self.client)], ["message_changed", "message_deleted"])

    async def test_complete_login_and_channel_flow_over_trusted_tls(self):
        key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "localhost")])
        now = datetime.datetime.now(datetime.timezone.utc)
        cert = (x509.CertificateBuilder().subject_name(name).issuer_name(name)
                .public_key(key.public_key()).serial_number(x509.random_serial_number())
                .not_valid_before(now - datetime.timedelta(minutes=1))
                .not_valid_after(now + datetime.timedelta(days=1))
                .add_extension(x509.SubjectAlternativeName([x509.DNSName("localhost"),
                               x509.IPAddress(ipaddress.ip_address("127.0.0.1"))]), critical=False)
                .sign(key, hashes.SHA256()))
        cert_file = Path(self.directory.name) / "cert.pem"
        key_file = Path(self.directory.name) / "key.pem"
        cert_file.write_bytes(cert.public_bytes(serialization.Encoding.PEM))
        key_file.write_bytes(key.private_bytes(serialization.Encoding.PEM,
                                              serialization.PrivateFormat.PKCS8,
                                              serialization.NoEncryption()))
        server_tls = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        server_tls.minimum_version = ssl.TLSVersion.TLSv1_3
        server_tls.load_cert_chain(cert_file, key_file)
        client_tls = ssl.create_default_context(cafile=str(cert_file))
        self.provider.start = AsyncMock(return_value={"user_code": "ABCD", "verification_uri": "https://id.example/verify",
                                                       "device_code": "private", "interval": 5, "expires_in": 300})
        self.provider.poll = AsyncMock(return_value=self.identity)
        server = await asyncio.start_server(self.relay.handle_client, "127.0.0.1", 0, ssl=server_tls, limit=4096)
        async with server:
            port = server.sockets[0].getsockname()[1]
            reader, writer = await asyncio.open_connection("127.0.0.1", port, ssl=client_tls, server_hostname="localhost")

            async def receive():
                return json.loads(await asyncio.wait_for(reader.readline(), 3))

            async def send(**request):
                writer.write((json.dumps(request) + "\n").encode())
                await writer.drain()

            try:
                self.assertEqual((await receive())["version"], 2)
                self.assertEqual(writer.get_extra_info("ssl_object").version(), "TLSv1.3")
                await send(op="login", id="login")
                self.assertEqual((await receive())["type"], "device")
                authenticated = await receive()
                self.assertEqual(authenticated["type"], "authenticated")
                self.assertNotIn("private", json.dumps(authenticated))
                await send(op="select_guild", id="g", guild_id="1")
                self.assertEqual((await receive())["type"], "selected_guild")
                await send(op="channels", id="cs")
                self.assertEqual((await receive())["type"], "channels_begin")
                self.assertEqual((await receive())["channel_id"], "11")
                self.assertEqual((await receive())["type"], "channels_end")
                await send(op="select_channel", id="c", channel_id="11")
                self.assertEqual((await receive())["type"], "selected_channel")
                self.user_perms.view_channel = False
                await self.relay.revalidate(1)
                self.assertEqual((await receive())["type"], "reset")
                await send(op="logout", id="out")
                self.assertEqual((await receive())["type"], "logged_out")
                self.assertEqual(await asyncio.wait_for(reader.readline(), 3), b"")
                self.assertEqual(self.relay.sessions, {})
            finally:
                writer.close()
                await writer.wait_closed()
                await self.relay.close()

    async def test_history_order_and_cursor(self):
        await self.select()

        async def history(**kwargs):
            for mid in (3, 2, 1):
                yield SimpleNamespace(guild=self.guild, channel=self.channel, id=mid,
                                      author=self.member, content="line\none", attachments=[])

        self.channel.history = history
        await self.relay.dispatch(self.client, {"op": "history", "id": "h", "limit": 3})
        result = events(self.client)
        self.assertEqual([event["message_id"] for event in result[1:-1]], ["1", "2", "3"])
        self.assertEqual(result[1]["text"], "line one")
        self.assertEqual(result[-1]["before"], "1")

    async def test_second_server_selection_replaces_subscription(self):
        await self.select()
        guild2 = Mock(id=2, unavailable=False, me=self.bot)
        guild2.get_member.return_value = self.member
        self.bridge.get_guild.side_effect = lambda gid: self.guild if gid == 1 else guild2
        await self.relay.dispatch(self.client, {"op": "select_guild", "id": "g2", "guild_id": "2"})
        self.assertEqual(self.client.guild_id, 2)
        self.assertIsNone(self.client.channel_id)
        events(self.client)
        await self.relay.publish("message", 1, 11, text="old server")
        self.assertEqual(events(self.client), [])

    def test_protocol_rejects_legacy_and_malformed_frames(self):
        for raw in (b"AUTH alice 1234\n", b"{}\n", b"[]\n", b"\xff\n", b"x" * 5000 + b"\n"):
            with self.assertRaises(RelayError):
                parse_request(raw)
        self.assertEqual(parse_request(b'{"op":"ping","id":"1"}\n')["op"], "ping")


if __name__ == "__main__":
    unittest.main()
