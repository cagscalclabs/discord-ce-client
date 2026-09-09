# Hosting the relay

This is the bot/relay implementation for Discord-CE's text chat. It uses OIDC
device login, verified Discord account linking, one active connection/server per
Discord user, permission-filtered channels, history, live messages, and bot sends.
The calculator's existing username/PIN protocol is no longer accepted. Its UI
must be updated to [protocol version 2](PROTOCOL.md) before using this relay.

## Setup

Use Python 3.10 or newer and a dedicated Discord application. From the repository root:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r relay/requirements.txt
cp relay/config.json.example relay/config.json
chmod 600 relay/config.json
```

Edit the config with your bot token and registered OIDC client ID. Select the
OIDC authentication method assigned to that registration and supply a client
secret if required. The registration must support the device-code grant with
the `openid` scope and return an RS256-signed ID token with a `kid` header.

Install the bot in each participating server with `bot` and
`applications.commands` scopes. Grant View Channels, Send Messages, and Read
Message History in participating channels. Enable **Server Members** and
**Message Content** privileged intents in the Discord Developer Portal (and
obtain approval where applicable). The member intent maintains the membership
and role cache used for authorization. See [discord.py's intent guide](https://discordpy.readthedocs.io/en/stable/intents.html).

Provide a TLS certificate chain and private key for the relay hostname. The
calculator must trust that certificate and validate the hostname. The listener
requires TLS 1.3; the certificate/key and negotiated group must be compatible
with lwIP-CE. The provider's TLS compatibility does not establish compatibility
with your independently hosted relay.

```sh
.venv/bin/python relay/relay.py
```

Startup validates configuration, loads TLS, opens the link database, discovers
OIDC endpoints, and registers `/relay_link` and `/relay_unlink` as global Discord
commands. Global command propagation can take time. Command synchronization
owns the application's global command set, so use a dedicated application.
The relay won't serve Discord data before the bot's cache is ready.

## Configuration

| Setting | Purpose |
| --- | --- |
| `DISCORD_TOKEN` | Bot token without a `Bot ` prefix. Required. |
| `PERMISSIONS` | Permission bitmask requested by the installation URL logged at startup. Default `68608` requests View Channels, Send Messages, and Read Message History. This does not grant permissions by itself. Environment override: `PERMISSIONS`. |
| `RELAY_HOST`, `RELAY_PORT` | Bind address and TCP port; defaults `0.0.0.0:8443`. Configure your firewall/DNS separately. |
| `RELAY_CERT`, `RELAY_KEY` | PEM certificate chain and private key paths. |
| `DATABASE_FILE` | SQLite database of verified account links. Default `relay.sqlite3`. Parent directory must exist and be writable. |
| `DISCORD_DISPLAY_FMT` | Outgoing attribution; must contain `{user}` and `{text}`. Default `[{user}] {text}`. |
| `SESSION_TTL` | Maximum relay session lifetime in seconds, default 3600, also capped by the ID token's expiry. |
| `LOGIN_TIMEOUT` | Total time to finish device login and first-time linking, default 600 seconds. |
| `MAX_CLIENTS`, `MAX_CLIENTS_PER_IP` | Concurrent connection limits; defaults 64 and 4. |
| `MAX_SESSIONS` | Maximum cached resumable sessions, default 1024. |
| `SEND_INTERVAL` | Minimum seconds between a user's sends across connections, default 2. Channel slowmode also applies unless the member is exempt. |
| `oidc.issuer` | Trusted OIDC issuer, default `https://account.ceagle.cc`. Endpoints are discovered at startup. |
| `oidc.client_id` | Required provider registration ID. This is not the Discord application ID. |
| `oidc.client_secret` | Provider client secret, if assigned. |
| `oidc.token_endpoint_auth_method` | `none`, `client_secret_basic`, or `client_secret_post`, matching the registration. |

Environment variables override JSON, which overrides defaults. Top-level fields
use matching environment names; OIDC overrides are `OIDC_ISSUER`,
`OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, and `OIDC_TOKEN_ENDPOINT_AUTH_METHOD`.
The default file is `config.json` beside `relay.py`, independent of launch directory.
Select a different host config with:

```sh
RELAY_CONFIG=/etc/discord-ce/config.json .venv/bin/python relay/relay.py
```

An explicitly selected file must exist. A missing default file permits
environment-only configuration. JSON/default relative file paths resolve from
the configuration directory; environment-supplied paths remain relative to the
working directory. Unknown settings are rejected. Remove the obsolete
`DISCORD_CHANNEL_ID` and `USERS_FILE` fields from older configurations.
`users.json` is no longer read; there is no PIN login fallback.

The local config, PEM files, and SQLite files under `relay/` are Git-ignored.
Keep custom paths private too. The database contains identity links, not
provider tokens. Back it up to preserve account links. Run one relay process
per deployment/database; connection ownership and sessions are in memory and
are not coordinated across replicas.

## Login and account linking

1. The calculator requests login and displays the provider's URL and user code.
2. The user approves in a browser on another device. The relay polls according
   to the provider's interval and handles pending, slow-down, denial, and expiry.
3. The relay validates the ID-token signature, issuer, audience, authorized party,
   required claims, and expiry against the discovered JWKS. It requests only
   `openid` and does not retain access/refresh tokens.
4. On first login, the calculator displays a separate link code. The user runs
   `/relay_link code:...` in a server where the bot is installed. The code is
   single-use and expires with the pending login.
5. The calculator displays the Discord account from that interaction. The user
   confirms its Discord ID with `link_confirm` before the association is saved.
   Do not approve a different account or enter a link code supplied by someone else.
6. The relay issues a random session token. Later logins use the saved verified
   link. The calculator can resume an unexpired session; resume rotates the
   token without extending its lifetime.

Each Discord account can link to one OIDC identity in this deployment. A new
login/resume replaces the user's previous connection and resets server selection.
`logout` revokes relay credentials; `/relay_unlink` also removes the account link
and closes that user's active connection. Restarting the relay invalidates all
sessions. Relay logout does not log the user out of the identity provider.
Provider-side logout/revocation is not pushed to the relay; a validated local
session lasts until its bounded expiry unless locally revoked. No automatic
refresh or `offline_access` is used.

## Access and message behavior

The user selects a mutual server, then a text channel visible to both their
Discord member and the bot. History additionally requires Read Message History
for both; sending requires Send Messages and no timeout. Read-only channels
remain selectable. Membership, roles, and channel overwrites come from the
Discord gateway cache. Cache updates recheck selections, and a disconnected
gateway clears selections and stops data delivery until ready again.

Switching servers resets the active channel. The client must erase the previous
view on selection/reset events and discard messages for other IDs. No private
DMs, threads, voice, reactions, webhook impersonation, or attachment downloads
are implemented. Text is bounded for the calculator; attachment counts and text
truncation flags are supplied. Edits trigger a refresh notification; deletes
identify the message to remove.

Sends use the authenticated Discord display name, suppress all mentions, and
acknowledge success only after Discord accepts the message. The gateway supplies
the message echo. A connection failure after Discord accepts a send can leave
its outcome unknown; request IDs correlate responses but are not idempotency
keys. Do not automatically retry an uncertain send.

## Verification

```sh
.venv/bin/python -m unittest discover -s relay -p 'test_*.py'
```

Tests use generated signing keys, fake provider responses, mocked Discord
objects, and local socket connections. They do not send messages to Discord or
exercise a live provider registration. Deployment still needs a real device
login, permission-revocation checks in a test server, and a TLS handshake from
the calculator.

Protocol references: [device grant](https://www.rfc-editor.org/rfc/rfc8628),
[OIDC validation](https://openid.net/specs/openid-connect-core-1_0.html#IDTokenValidation),
and [PyJWT usage](https://pyjwt.readthedocs.io/en/stable/usage.html).
