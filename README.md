# discord-ce

Discord-CE is intended to be a thin Discord client for use on the TI-84+ CE graphing calculator via lwIP-CE, WiTi, or any other flavor of networking.

**Note**:

Discord's Terms of Service prohibit true custom clients that log in as a user. This means this client must send requests to a Discord bot, which manages user-identity locally, before pushing/pulling content to a server.

Message history and live chat are relayed through a Discord bot. Outgoing messages
are posted by that bot with user attribution. Login uses OAuth2/OIDC device authorization.

Current project layout:
src/ => Calculator side
relay/ => Bot code

For host-specific bot configuration, see [relay setup](relay/README.md) and
copy [the example configuration](relay/config.json.example) to `relay/config.json`.

*Code mostly written by Claude Sonnet so, a review for correctness/efficiency is in order.*

## Intended design

The calculator connects over TLS to a relay service, which connects to Discord through a bot installed in participating servers. The calculator UI uses a purple/black theme, with channels on the left and chat on the right. Bot credentials stay on the relay; calculator users never supply Discord user account tokens.

- Each authenticated user can connect to one server at a time. The relay enforces this across the user's connections. Switching servers replaces subscriptions and clears the previous server's channels and chat.
- Only servers accessible to the bot are eligible. The default access policy should also require verified user membership and channel permissions, so bot visibility cannot expose private channels to unauthorized users.
- Access checks apply to channel lists, history, live delivery, and sends, including when permissions or membership change.
- Server and channel IDs identify destinations; names are display labels that may be duplicated or truncated.
- Messages are sent by the bot with attribution derived from the authenticated identity. Any future webhook credentials belong on the relay, rather than the calculator.

Discord documents bot APIs and OAuth2 as integration mechanisms and prohibits self-bots. Using a bot does not itself guarantee policy compliance. Message history and sends require appropriate channel permissions; receiving ordinary message text also depends on the Message Content intent and applicable approval requirements. References: [OAuth2](https://docs.discord.com/developers/topics/oauth2), [channel permissions](https://docs.discord.com/developers/platform/server-and-channel-management), and [Gateway intents](https://docs.discord.com/developers/events/gateway).

## OAuth2 / OpenID Connect

The intended identity provider is Alessio's OAuth2/OpenID Connect server, with a TLS configuration designed for lwIP-CE compatibility. The supplied discovery screenshots advertise the following metadata (not yet verified against the live service):

| Setting | Value |
| --- | --- |
| Issuer | `https://account.ceagle.cc` |
| Discovery URL shown as service documentation | `https://account.ceagle.cc/.well-known/openid-configuration` |
| Authorization endpoint | `https://account.ceagle.cc/oauth2/authorize` |
| Device authorization endpoint | `https://account.ceagle.cc/oauth2/device_authorization` |
| Token endpoint | `https://account.ceagle.cc/oauth2/token` |
| UserInfo endpoint | `https://account.ceagle.cc/oauth2/userinfo` |
| JWKS URI | `https://account.ceagle.cc/.well-known/jwks.json` |
| Revocation endpoint | `https://account.ceagle.cc/oauth2/revoke` |
| Introspection endpoint | `https://account.ceagle.cc/oauth2/introspect` |
| End-session endpoint | `https://account.ceagle.cc/oauth2/logout` |
| Grants | `authorization_code`, `refresh_token`, `urn:ietf:params:oauth:grant-type:device_code` |
| Scopes | `openid`, `profile`, `email`, `offline_access` |
| ID-token signing | `RS256` |
| Token endpoint authentication | `client_secret_basic`, `client_secret_post`, `none` |
| Authorization-code PKCE | `S256` |

These are provider capabilities; the registered Discord-CE client still needs permission to use the chosen grant and authentication method. The signing algorithm describes ID tokens, not the TLS certificate or cipher configuration.

User login and the bot connection are separate: OpenID Connect establishes user identity, while the relay connects to Discord with its bot token. An external identity needs a verified Discord account link before it can be used to check Discord membership and permissions.

A device-code login is implemented on the relay, based on the advertised grant:

1. The calculator requests login from the relay over TLS.
2. The relay requests device authorization and binds the pending login to that calculator connection. It returns the provider's user code and verification URI for display, keeping the device code on the relay.
3. The user visits that URI on a phone or computer and approves the login.
4. The relay polls the token endpoint, respecting the provider's interval, pending/slow-down responses, expiry, and denial. See [RFC 8628](https://www.rfc-editor.org/rfc/rfc8628).
5. On first login, the user links their Discord identity with `/relay_link` and confirms the displayed account on the calculator. The relay then issues its own bounded calculator session. Provider tokens and any client secret stay on the relay.

The advertised claims include standard identity fields such as `sub`, `preferred_username`, `email`, and `email_verified`, but no explicit Discord account ID. The bot's slash-command interaction supplies the verified Discord ID; usernames and email addresses are not used to infer account links.

Live deployment still needs client registration details and confirmation of OIDC token behavior for the device grant. Relay sessions expire, rotate on resume, and can be revoked locally. Provider logout does not immediately revoke a local relay session. The exact TLS profile and certificate trust requirements must also be verified for the calculator-to-relay connection. Discovery metadata alone does not establish TLS compatibility.

## Prototype versus intended behavior

| Component | Current implementation |
| --- | --- |
| `src/main.c` | Channel sidebar and chat pane; light theme; saved username/PIN authentication; TLS line protocol. |
| `relay/relay.py` | OIDC device login, confirmed Discord account links, expiring sessions, history/live chat, and bot sends using protocol v2. |
| Channel selection | Mutual-server selection, stable channel IDs, user/bot permission checks, one active connection/server per Discord user. |
| TLS | Relay requires TLS 1.3; compatibility with Alessio's profile and the calculator needs verification. |
| Build | CE toolchain; calculator source also depends on lwIP headers and `../../common/lwip_example.h` outside this repository. |

The relay has automated tests with simulated Discord/provider responses; live integration and calculator TLS compatibility remain unverified. Its [version 2 protocol](relay/PROTOCOL.md) intentionally replaces username/PIN login. `src/main.c` still speaks the old protocol and must be updated with device login, account confirmation, server selection, and the purple/black theme. The old PIN user file is no longer used by the relay.
