# discord-ce

[![Tests](https://github.com/cagscalclabs/discord-ce-client/actions/workflows/test.yml/badge.svg)](https://github.com/cagscalclabs/discord-ce-client/actions/workflows/test.yml)
[![CodeQL](https://github.com/cagscalclabs/discord-ce-client/actions/workflows/codeql.yml/badge.svg)](https://github.com/cagscalclabs/discord-ce-client/actions/workflows/codeql.yml)

Discord-CE is a thin Discord client for the TI-84+ CE graphing calculator, using lwIP-CE for TLS networking.

**Note**: Discord's Terms of Service prohibit custom clients that log in directly as a user. This client sends requests to a Discord bot, which manages user identity and relays content to and from Discord servers. Outgoing messages are posted by the bot with user attribution. Login uses OAuth2/OIDC device authorization.

For the server-side/bot check out this repo: https://github.com/cagscalclabs/discord-ce-server

## Design

The calculator connects over TLS to a Discord bot acting as a relay service, which connects to Discord through a bot installed in participating servers. The UI uses a purple/black theme with a channel list on the left and chat on the right. Bot credentials stay on the relay; calculator users never supply Discord account tokens.

- Each authenticated user can connect to one server at a time. Switching servers replaces the subscription and clears the previous server's channels and chat.
- Only servers accessible to the bot are eligible. Access policy requires verified user membership and channel permissions, so bot visibility cannot expose private channels to unauthorized users.
- Access checks apply to channel lists, history, live delivery, and sends, including when permissions or membership change mid-session.
- Server and channel IDs identify destinations; names are display labels that may be duplicated or truncated.
- Messages are sent by the bot with attribution derived from the authenticated identity.

Discord documents bot APIs and OAuth2 as integration mechanisms and prohibits self-bots. Using a bot does not itself guarantee policy compliance. Message history and sends require appropriate channel permissions; receiving message text also depends on the Message Content intent and applicable approval requirements. References: [OAuth2](https://docs.discord.com/developers/topics/oauth2), [channel permissions](https://docs.discord.com/developers/platform/server-and-channel-management), and [Gateway intents](https://docs.discord.com/developers/events/gateway).

## OAuth2 / OpenID Connect

The identity provider is Alessio's OAuth2/OIDC server at `https://account.ceagle.cc`, with a TLS configuration designed for lwIP-CE compatibility.

User login and the bot connection are separate: OIDC establishes user identity; the relay connects to Discord with its bot token. An external identity requires a verified Discord account link before it can be used to check Discord membership and permissions.

Device-code login flow:

1. The calculator requests login from the relay over TLS.
2. The relay requests device authorization and returns the provider's user code and verification URI for display. The device code stays on the relay.
3. The user visits that URI on a phone or computer and approves the login.
4. The relay polls the token endpoint per [RFC 8628](https://www.rfc-editor.org/rfc/rfc8628), respecting the provider's interval, slow-down responses, expiry, and denial.
5. On first login, the user links their Discord identity with `/relay_link` and confirms the displayed account on the calculator. The relay then issues its own bounded session token. Provider tokens and any client secret stay on the relay. Subsequent logins resume silently using the stored session token.

The bot's slash-command interaction supplies the verified Discord ID; usernames and email addresses are not used to infer account links.

Relay sessions expire, rotate on resume, and can be revoked locally. Provider logout does not immediately revoke a local relay session. The exact TLS profile and certificate trust requirements must be verified for the calculator-to-relay connection.

## Current status

| Component | Status |
| --- | --- |
| `src/main.c` | Purple/black channel/chat UI; device login, account confirmation, session resume; relay protocol over TLS. |
| Channel selection | Mutual-server selection, stable channel IDs, user/bot permission checks, one active connection per Discord user. |
| TLS | Relay requires TLS 1.3; compatibility with Alessio's profile and the calculator needs verification. |
| Build | CE toolchain and installed lwIP headers/library. `src/lwip_example.h` is vendored directly in this repo. Produces `bin/DISC.8xp`. |

Client state-machine tests run on the host with AddressSanitizer and UBSan. Relay tests use simulated Discord/provider responses and localhost TLS. Hardware and live OIDC integration are verified working. The inspected lwIP checkout has a [certificate trust limitation](CLIENT.md#tls-dependency-status) to resolve before production credentials are used.
