#!/usr/bin/env python3
"""Discord-CE text relay. See README.md and PROTOCOL.md for hosting and wire format."""

import asyncio
from collections import deque
from contextlib import suppress
from dataclasses import dataclass
import hashlib
import json
import logging
import os
import secrets
import sqlite3
import ssl
import time

import aiohttp
import discord
from discord import app_commands

from config import ConfigError, load_config, validate_runtime
from oidc import AuthError, Identity, OIDCProvider


log = logging.getLogger("relay")
MAX_LINE = 4096
MAX_TEXT = 512
PAGE_SIZE = 24


class RelayError(Exception):
    """A non-sensitive protocol error code."""


def label(value, limit=80):
    return "".join(char if char.isprintable() else " " for char in str(value))[:limit]


def snowflake(value):
    if not isinstance(value, str) or not value.isascii() or not value.isdecimal():
        raise RelayError("invalid_id")
    if not 0 < int(value) < 2**64:
        raise RelayError("invalid_id")
    return int(value)


def parse_request(raw):
    if len(raw) > MAX_LINE or not raw.endswith(b"\n"):
        raise RelayError("invalid_frame")
    try:
        request = json.loads(raw.decode("utf-8"))
    except (ValueError, UnicodeError, RecursionError):
        raise RelayError("invalid_json") from None
    if (not isinstance(request, dict) or not isinstance(request.get("op"), str)
            or not isinstance(request.get("id"), str) or not 1 <= len(request["id"]) <= 32):
        raise RelayError("invalid_request")
    return request


class LinkStore:
    """Only verified issuer/subject -> Discord ID links are persisted."""

    def __init__(self, path):
        # Restrict the database before SQLite writes any identity data.
        fd = os.open(path, os.O_CREAT | os.O_RDWR, 0o600)
        os.close(fd)
        os.chmod(path, 0o600)
        self.db = sqlite3.connect(path)
        self.db.execute("CREATE TABLE IF NOT EXISTS links (issuer TEXT NOT NULL, "
                        "subject TEXT NOT NULL, discord_id TEXT NOT NULL UNIQUE, "
                        "PRIMARY KEY (issuer, subject))")
        self.db.commit()

    def lookup(self, identity):
        row = self.db.execute("SELECT discord_id FROM links WHERE issuer=? AND subject=?",
                              (identity.issuer, identity.subject)).fetchone()
        return int(row[0]) if row else None

    def add(self, identity, user_id):
        try:
            with self.db:
                self.db.execute("INSERT INTO links VALUES (?, ?, ?)",
                                (identity.issuer, identity.subject, str(user_id)))
        except sqlite3.IntegrityError:
            raise RelayError("already_linked") from None

    def remove(self, user_id):
        with self.db:
            self.db.execute("DELETE FROM links WHERE discord_id=?", (str(user_id),))

    def close(self):
        self.db.close()


@dataclass
class Session:
    identity: Identity
    user_id: int
    expires_at: float


class CalcClient:
    def __init__(self, reader, writer, login_timeout):
        self.reader, self.writer = reader, writer
        self.ip = writer.get_extra_info("peername", ("unknown",))[0]
        self.deadline = time.monotonic() + login_timeout
        self.session = None
        self.identity = None
        self.guild_id = None
        self.channel_id = None
        self.link_code = None
        self.link_candidate = None
        self.login_task = None
        self.lock = asyncio.Lock()
        self.closed = False
        self.commands = deque()
        self.outgoing = asyncio.Queue(maxsize=64)

    async def emit(self, event, **fields):
        if self.closed:
            return
        raw = (json.dumps({"type": event, **fields}, ensure_ascii=False,
                          separators=(",", ":")) + "\n").encode("utf-8")
        if len(raw) > MAX_LINE:
            raise RelayError("response_too_large")
        try:
            self.outgoing.put_nowait(raw)
        except asyncio.QueueFull:
            self.close()

    async def pump(self):
        try:
            while not self.closed:
                raw = await self.outgoing.get()
                self.writer.write(raw)
                await asyncio.wait_for(self.writer.drain(), 5)
        except (ConnectionError, OSError, asyncio.TimeoutError):
            self.close()

    def close(self):
        self.closed = True
        self.link_code = None
        self.link_candidate = None
        self.writer.close()


class RelayServer:
    def __init__(self, config, provider, store):
        self.config, self.provider, self.store = config, provider, store
        self.clients = set()
        self.handlers = set()
        self.sessions = {}  # SHA-256 of random bearer tokens; never persist tokens.
        self.active = {}  # One connection per verified Discord account.
        self.connection_attempts = {}
        self.send_cooldowns = {}
        self.bridge = None

    def expire_sessions(self):
        now = time.time()
        self.sessions = {key: value for key, value in self.sessions.items()
                         if value.expires_at > now}

    def revoke(self, user_id):
        self.sessions = {key: value for key, value in self.sessions.items()
                         if value.user_id != user_id}
        previous = self.active.pop(user_id, None)
        if previous:
            previous.close()

    def allowed_connection(self, ip):
        now = time.monotonic()
        self.connection_attempts = {key: value for key, value in self.connection_attempts.items()
                                    if value[-1] > now - 60}
        if ip not in self.connection_attempts and len(self.connection_attempts) >= 4096:
            return False
        attempts = self.connection_attempts.setdefault(ip, deque())
        while attempts and attempts[0] <= now - 60:
            attempts.popleft()
        if len(attempts) >= 10:
            return False
        attempts.append(now)
        return (len(self.clients) < self.config["MAX_CLIENTS"] and
                sum(client.ip == ip for client in self.clients) < self.config["MAX_CLIENTS_PER_IP"])

    async def handle_client(self, reader, writer):
        client = CalcClient(reader, writer, self.config["LOGIN_TIMEOUT"])
        if not self.allowed_connection(client.ip):
            writer.close()
            return
        self.clients.add(client)
        self.handlers.add(asyncio.current_task())
        pump = asyncio.create_task(client.pump())
        try:
            await client.emit("hello", version=2, max_text=MAX_TEXT)
            while not client.closed:
                timeout = (client.session.expires_at - time.time() if client.session
                           else client.deadline - time.monotonic())
                if timeout <= 0:
                    break
                try:
                    raw = await asyncio.wait_for(reader.readline(), min(timeout, 30))
                except asyncio.TimeoutError:
                    continue
                if not raw:
                    break
                request = parse_request(raw)
                now = time.monotonic()
                while client.commands and client.commands[0] <= now - 10:
                    client.commands.popleft()
                if len(client.commands) >= 20:
                    raise RelayError("rate_limited")
                client.commands.append(now)
                async with client.lock:
                    if client.closed:
                        break
                    try:
                        await self.dispatch(client, request)
                    except RelayError as exc:
                        await client.emit("error", id=request["id"], code=str(exc))
                    except discord.HTTPException:
                        await client.emit("error", id=request["id"], code="discord_unavailable")
        except (ConnectionError, OSError, asyncio.TimeoutError, ValueError, RelayError):
            pass
        except Exception:
            # Do not print requests, provider responses, session tokens or message contents.
            log.error("Unexpected relay client failure")
        finally:
            client.close()
            self.clients.discard(client)
            if client.session and self.active.get(client.session.user_id) is client:
                self.active.pop(client.session.user_id, None)
            tasks = [pump]
            if client.login_task:
                tasks.append(client.login_task)
            for task in tasks:
                task.cancel()
            await asyncio.gather(*tasks, return_exceptions=True)
            with suppress(ConnectionError, OSError, asyncio.TimeoutError):
                await asyncio.wait_for(writer.wait_closed(), 5)
            self.handlers.discard(asyncio.current_task())

    async def login(self, client, request_id):
        try:
            device = await self.provider.start()
            deadline = min(client.deadline, time.monotonic() + device["expires_in"])
            await client.emit("device", id=request_id, user_code=device["user_code"],
                              verification_uri=device["verification_uri"],
                              expires_in=max(0, int(deadline - time.monotonic())))
            identity = await self.provider.poll(device, deadline)
            async with client.lock:
                if client.closed or time.monotonic() >= client.deadline:
                    return
                client.identity = identity
                linked = self.store.lookup(identity)
                if linked:
                    await self.authenticate(client, identity, linked, request_id)
                else:
                    client.link_code = secrets.token_hex(8).upper()
                    await client.emit("link_required", id=request_id, code=client.link_code,
                                      command="/relay_link", expires_in=max(0, int(
                                          min(client.deadline - time.monotonic(), identity.expires_at - time.time()))))
        except AuthError as exc:
            await client.emit("error", id=request_id, code=str(exc))
        except RelayError as exc:
            await client.emit("error", id=request_id, code=str(exc))
        except Exception:
            log.error("Device login failed")
            await client.emit("error", id=request_id, code="login_failed")

    async def authenticate(self, client, identity, user_id, request_id):
        expires = min(identity.expires_at, time.time() + self.config["SESSION_TTL"])
        if expires <= time.time():
            raise RelayError("session_expired")
        # Rotating credentials also invalidates every previous connection/session.
        self.expire_sessions()
        if (len(self.sessions) >= self.config["MAX_SESSIONS"] and
                not any(session.user_id == user_id for session in self.sessions.values())):
            raise RelayError("server_busy")
        self.revoke(user_id)
        token = secrets.token_urlsafe(32)
        session = Session(identity, user_id, expires)
        self.sessions[hashlib.sha256(token.encode()).digest()] = session
        client.session = session
        client.identity = None
        client.link_code = None
        client.link_candidate = None
        client.guild_id = client.channel_id = None
        self.active[user_id] = client
        await client.emit("authenticated", id=request_id, token=token,
                          discord_id=str(user_id), expires_at=int(expires))

    def require_session(self, client):
        if not client.session:
            raise RelayError("authentication_required")
        if (client.session.expires_at <= time.time() or client.closed or
                self.active.get(client.session.user_id) is not client):
            raise RelayError("session_expired")
        if not self.bridge or not self.bridge.is_ready():
            raise RelayError("discord_unavailable")

    async def dispatch(self, client, request):
        op, request_id = request["op"], request["id"]
        if op == "ping":
            await client.emit("pong", id=request_id)
            return
        if op == "login":
            if client.session or client.login_task:
                raise RelayError("login_already_started")
            client.login_task = asyncio.create_task(self.login(client, request_id))
            return
        if op == "resume":
            if client.session or client.login_task:
                raise RelayError("login_already_started")
            token = request.get("token")
            if not isinstance(token, str) or len(token) != 43:
                raise RelayError("invalid_session")
            self.expire_sessions()
            session = self.sessions.pop(hashlib.sha256(token.encode()).digest(), None)
            if not session or self.store.lookup(session.identity) != session.user_id:
                raise RelayError("invalid_session")
            # Resume never extends the original session lifetime.
            identity = Identity(session.identity.issuer, session.identity.subject, session.expires_at)
            await self.authenticate(client, identity, session.user_id, request_id)
            return
        if op == "link_confirm":
            if (not client.identity or not client.link_candidate or
                    time.time() >= client.identity.expires_at or time.monotonic() >= client.deadline):
                raise RelayError("link_expired")
            candidate_id, _ = client.link_candidate
            if snowflake(request.get("discord_id")) != candidate_id:
                raise RelayError("link_mismatch")
            self.store.add(client.identity, candidate_id)
            await self.authenticate(client, client.identity, candidate_id, request_id)
            return
        if op == "logout":
            if client.session:
                # Send acknowledgement before the receive loop closes this socket.
                self.sessions = {key: value for key, value in self.sessions.items()
                                 if value.user_id != client.session.user_id}
                self.active.pop(client.session.user_id, None)
                client.session = None
            client.identity = client.link_code = client.link_candidate = None
            if client.login_task:
                client.login_task.cancel()
            await client.emit("logged_out", id=request_id)
            # Keep socket open only long enough for the output pump to flush.
            client.deadline = time.monotonic() + 1
            return
        self.require_session(client)
        if op == "guilds":
            rows = self.bridge.visible_guilds(client.session.user_id)
            await self.page(client, request, "guild", rows)
        elif op == "select_guild":
            guild_id = snowflake(request.get("guild_id"))
            self.bridge.guild_member(guild_id, client.session.user_id)
            client.guild_id, client.channel_id = guild_id, None
            await client.emit("selected_guild", id=request_id, guild_id=str(guild_id))
        elif op == "channels":
            rows = self.bridge.visible_channels(client)
            await self.page(client, request, "channel", rows)
        elif op == "select_channel":
            channel = self.bridge.access(client, snowflake(request.get("channel_id")))
            client.channel_id = channel.id
            await client.emit("selected_channel", id=request_id,
                              guild_id=str(client.guild_id), channel_id=str(channel.id))
        elif op == "send":
            text = request.get("text")
            if (not isinstance(text, str) or not text.strip() or len(text) > MAX_TEXT
                    or any(not char.isprintable() for char in text)):
                raise RelayError("invalid_text")
            now = time.monotonic()
            channel = self.bridge.access(client, client.channel_id, send=True)
            _, member = self.bridge.guild_member(client.guild_id, client.session.user_id)
            user_id = client.session.user_id
            self.send_cooldowns = {key: expiry for key, expiry in self.send_cooldowns.items() if expiry > now}
            if any(key in self.send_cooldowns for key in ((user_id, None), (user_id, channel.id))):
                raise RelayError("rate_limited")
            self.send_cooldowns[user_id, None] = now + self.config["SEND_INTERVAL"]
            perms = channel.permissions_for(member)
            if not (perms.manage_channels or perms.manage_messages):
                self.send_cooldowns[user_id, channel.id] = now + channel.slowmode_delay
            author = discord.utils.escape_markdown(label(member.display_name))
            rendered = self.config["DISCORD_DISPLAY_FMT"].format(user=author, text=text)
            message = await channel.send(rendered, allowed_mentions=discord.AllowedMentions.none())
            await client.emit("sent", id=request_id, message_id=str(message.id),
                              guild_id=str(channel.guild.id), channel_id=str(channel.id))
        elif op == "history":
            channel = self.bridge.access(client, client.channel_id, history=True)
            limit = request.get("limit", 20)
            if type(limit) is not int or not 1 <= limit <= 50:
                raise RelayError("invalid_limit")
            before = discord.Object(id=snowflake(request["before"])) if "before" in request else None
            # Fetch first, then recheck access: permissions may change during HTTP awaits.
            messages = [message async for message in channel.history(limit=limit, before=before)]
            self.require_session(client)
            self.bridge.access(client, channel.id, history=True)
            await client.emit("history_begin", id=request_id, channel_id=str(channel.id))
            for message in reversed(messages):
                await client.emit("message", id=request_id, history=True, **self.message_fields(message))
            await client.emit("history_end", id=request_id, channel_id=str(channel.id),
                              before=str(messages[-1].id) if len(messages) == limit else None)
        else:
            raise RelayError("unknown_operation")

    async def page(self, client, request, kind, rows):
        offset = request.get("offset", 0)
        if type(offset) is not int or not 0 <= offset <= 100000:
            raise RelayError("invalid_offset")
        await client.emit(kind + "s_begin", id=request["id"])
        for row in rows[offset:offset + PAGE_SIZE]:
            await client.emit(kind, id=request["id"], **row)
        following = offset + PAGE_SIZE
        await client.emit(kind + "s_end", id=request["id"],
                          next_offset=following if following < len(rows) else None)

    @staticmethod
    def message_fields(message):
        content = label(message.content, MAX_TEXT)
        return {"guild_id": str(message.guild.id), "channel_id": str(message.channel.id),
                "message_id": str(message.id), "author_id": str(message.author.id),
                "author": label(message.author.display_name), "text": content,
                "truncated": len(message.content) > MAX_TEXT,
                "attachments": len(message.attachments)}

    async def publish(self, event, target_guild, target_channel, **fields):
        # No awaits that yield between permission checks and queueing. Commands can
        # await Discord HTTP, but live delivery always uses current selected IDs.
        for client in tuple(self.clients):
            if client.guild_id != target_guild or client.channel_id != target_channel:
                continue
            try:
                self.require_session(client)
                self.bridge.access(client, target_channel)
                await client.emit(event, **fields)
            except RelayError:
                await self.clear_selection(client)

    async def clear_selection(self, client):
        client.guild_id = client.channel_id = None
        # Remove queued content before telling the calculator to erase its view.
        retained = []
        while not client.outgoing.empty():
            raw = client.outgoing.get_nowait()
            if json.loads(raw)["type"] in {"hello", "device", "link_required", "link_candidate", "authenticated"}:
                retained.append(raw)
        for raw in retained:
            client.outgoing.put_nowait(raw)
        await client.emit("reset", reason="access_changed")

    async def revalidate(self, guild_id):
        for client in tuple(self.clients):
            if client.guild_id != guild_id:
                continue
            try:
                self.require_session(client)
                self.bridge.guild_member(guild_id, client.session.user_id)
                if client.channel_id:
                    self.bridge.access(client, client.channel_id)
                await client.emit("channels_changed", guild_id=str(guild_id))
            except RelayError:
                await self.clear_selection(client)

    async def claim_link(self, code, user_id, username):
        for client in tuple(self.clients):
            async with client.lock:
                if (not client.closed and client.link_code and
                        secrets.compare_digest(client.link_code, code.upper()) and
                        client.identity and client.identity.expires_at > time.time() and
                        client.deadline > time.monotonic()):
                    client.link_code = None
                    client.link_candidate = (user_id, username)
                    await client.emit("link_candidate", discord_id=str(user_id), name=label(username))
                    return True
        return False

    async def unlink(self, user_id):
        self.store.remove(user_id)
        self.revoke(user_id)
        for client in tuple(self.clients):
            if client.link_candidate and client.link_candidate[0] == user_id:
                client.close()

    async def close(self):
        for client in tuple(self.clients):
            client.close()
        if self.handlers:
            for task in tuple(self.handlers):
                task.cancel()
            await asyncio.gather(*tuple(self.handlers), return_exceptions=True)


class DiscordBridge(discord.Client):
    def __init__(self, relay):
        intents = discord.Intents(guilds=True, members=True, guild_messages=True,
                                  message_content=True)
        super().__init__(intents=intents, allowed_mentions=discord.AllowedMentions.none())
        self.relay = relay
        relay.bridge = self
        self.tree = app_commands.CommandTree(self)

        @self.tree.command(name="relay_link", description="Link your Discord account to your calculator login")
        @app_commands.guild_only()
        @app_commands.checks.cooldown(3, 60, key=lambda interaction: interaction.user.id)
        async def relay_link(interaction: discord.Interaction, code: str):
            await interaction.response.defer(ephemeral=True)
            valid = (len(code) == 16 and code.isascii() and
                     await relay.claim_link(code, interaction.user.id, interaction.user.display_name))
            await interaction.followup.send(
                "Confirm this Discord account on your calculator to finish linking." if valid else
                "That code is invalid or expired. Start a new calculator login.", ephemeral=True)

        @self.tree.command(name="relay_unlink", description="Remove your calculator account link and revoke relay sessions")
        @app_commands.guild_only()
        async def relay_unlink(interaction: discord.Interaction):
            await interaction.response.defer(ephemeral=True)
            await relay.unlink(interaction.user.id)
            await interaction.followup.send("Account link removed and relay sessions revoked.", ephemeral=True)

        @self.tree.error
        async def command_error(interaction: discord.Interaction, error: app_commands.AppCommandError):
            message = "Command unavailable. Please try again later."
            if interaction.response.is_done():
                await interaction.followup.send(message, ephemeral=True)
            else:
                await interaction.response.send_message(message, ephemeral=True)

    async def setup_hook(self):
        # Use a dedicated Discord application: syncing owns its global commands.
        await self.tree.sync()
        log.info("Bot installation URL: %s", discord.utils.oauth_url(
            self.application_id, permissions=discord.Permissions(self.relay.config["PERMISSIONS"]),
            scopes=("bot", "applications.commands")))

    def guild_member(self, guild_id, user_id):
        guild = self.get_guild(guild_id) if guild_id else None
        if not self.is_ready() or not guild or guild.unavailable or not guild.me:
            raise RelayError("guild_unavailable")
        member = guild.get_member(user_id)
        if member is None:
            raise RelayError("access_denied")
        return guild, member

    def access(self, client, channel_id, send=False, history=False):
        guild, member = self.guild_member(client.guild_id, client.session.user_id)
        channel = guild.get_channel(channel_id) if channel_id else None
        if not isinstance(channel, discord.TextChannel):
            raise RelayError("channel_unavailable")
        for actor in (guild.me, member):
            perms = channel.permissions_for(actor)
            if (not perms.view_channel or (history and not perms.read_message_history)
                    or (send and (not perms.send_messages or actor.is_timed_out()))):
                raise RelayError("access_denied")
        return channel

    def visible_guilds(self, user_id):
        rows = []
        for guild in sorted(self.guilds, key=lambda item: item.id):
            try:
                self.guild_member(guild.id, user_id)
            except RelayError:
                continue
            rows.append({"guild_id": str(guild.id), "name": label(guild.name)})
        return rows

    def visible_channels(self, client):
        guild, _ = self.guild_member(client.guild_id, client.session.user_id)
        rows = []
        for channel in sorted(guild.text_channels, key=lambda item: (item.position, item.id)):
            try:
                self.access(client, channel.id)
            except RelayError:
                continue
            row = {"guild_id": str(guild.id), "channel_id": str(channel.id),
                   "name": label(channel.name), "can_send": False, "can_history": False}
            for key, kwargs in (("can_send", {"send": True}), ("can_history", {"history": True})):
                try:
                    self.access(client, channel.id, **kwargs)
                    row[key] = True
                except RelayError:
                    pass
            rows.append(row)
        return rows

    async def on_ready(self):
        log.info("Discord bot ready; %d server(s)", len(self.guilds))
        for guild in self.guilds:
            await self.relay.revalidate(guild.id)

    async def on_disconnect(self):
        for client in tuple(self.relay.clients):
            await self.relay.clear_selection(client)

    async def on_message(self, message):
        if isinstance(message.channel, discord.TextChannel):
            await self.relay.publish("message", message.guild.id, message.channel.id,
                                     **self.relay.message_fields(message))

    async def on_raw_message_delete(self, payload):
        if payload.guild_id:
            await self.relay.publish("message_deleted", payload.guild_id, payload.channel_id,
                                     message_id=str(payload.message_id), channel_id=str(payload.channel_id),
                                     guild_id=str(payload.guild_id))

    async def on_raw_bulk_message_delete(self, payload):
        for message_id in payload.message_ids:
            await self.relay.publish("message_deleted", payload.guild_id, payload.channel_id,
                                     message_id=str(message_id), channel_id=str(payload.channel_id),
                                     guild_id=str(payload.guild_id))

    async def on_raw_message_edit(self, payload):
        # Tell clients to refresh history; never forward partial/unverified payload content.
        if payload.guild_id:
            await self.relay.publish("message_changed", payload.guild_id, payload.channel_id,
                                     message_id=str(payload.message_id), channel_id=str(payload.channel_id),
                                     guild_id=str(payload.guild_id))

    async def on_guild_channel_update(self, before, after):
        await self.relay.revalidate(after.guild.id)

    async def on_guild_channel_create(self, channel):
        await self.relay.revalidate(channel.guild.id)

    async def on_guild_channel_delete(self, channel):
        await self.relay.revalidate(channel.guild.id)

    async def on_member_update(self, before, after):
        await self.relay.revalidate(after.guild.id)

    async def on_member_remove(self, member):
        await self.relay.revalidate(member.guild.id)

    async def on_guild_role_update(self, before, after):
        await self.relay.revalidate(after.guild.id)

    async def on_guild_role_delete(self, role):
        await self.relay.revalidate(role.guild.id)

    async def on_guild_update(self, before, after):
        await self.relay.revalidate(after.id)

    async def on_guild_remove(self, guild):
        await self.relay.revalidate(guild.id)

    async def on_guild_unavailable(self, guild):
        await self.relay.revalidate(guild.id)


async def main():
    config = load_config()
    validate_runtime(config)
    tls = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    tls.minimum_version = ssl.TLSVersion.TLSv1_3
    tls.load_cert_chain(config["RELAY_CERT"], config["RELAY_KEY"])
    store = LinkStore(config["DATABASE_FILE"])
    try:
        async with aiohttp.ClientSession(timeout=aiohttp.ClientTimeout(total=20)) as http:
            provider = OIDCProvider(config["oidc"], http)
            await provider.discover()
            relay = RelayServer(config, provider, store)
            async with DiscordBridge(relay) as bridge:
                server = await asyncio.start_server(relay.handle_client, config["RELAY_HOST"],
                                                    config["RELAY_PORT"], ssl=tls, limit=MAX_LINE,
                                                    ssl_handshake_timeout=10)
                log.info("Relay listening on %s:%d (TLS 1.3, protocol 2)",
                         config["RELAY_HOST"], config["RELAY_PORT"])
                try:
                    async with server:
                        await bridge.start(config["DISCORD_TOKEN"])
                finally:
                    await relay.close()
    finally:
        store.close()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
    except (ConfigError, AuthError) as exc:
        raise SystemExit(f"Startup error: {exc}") from None
    except Exception:
        # Library exception strings may contain endpoints or credentials.
        raise SystemExit("Relay stopped: check credentials, intents, TLS files, database and service availability.") from None
