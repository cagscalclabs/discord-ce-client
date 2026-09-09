# Calculator relay protocol, version 2

Transport is TLS TCP. Each frame is one UTF-8 JSON object followed by LF, at most
4096 bytes including LF. JSON escaping keeps message text from creating frames.
Malformed/oversized frames and excessive command rates close the connection.
Legacy `AUTH user pin`, `CHAN name`, and `SEND text` lines are not supported.

Every request has `op` and a nonempty string `id` (at most 32 characters).
Responses have `type` and echo the request `id`; unsolicited events omit `id`.
All Discord IDs are decimal strings, never JSON numbers. Requests are processed
in order, but asynchronous login and Discord events may interleave. Use unique
request IDs until their responses complete.

On connect:

```json
{"type":"hello","version":2,"max_text":512}
```

## Authentication

```json
{"op":"login","id":"login1"}
{"type":"device","id":"login1","user_code":"ABCD-EFGH","verification_uri":"https://provider.example/verify","expires_in":600}
```

Display the returned URI and code verbatim. The relay polls the provider; the
calculator does not poll the token endpoint. First-time login then returns:

```json
{"type":"link_required","id":"login1","code":"0123456789ABCDEF","command":"/relay_link","expires_in":400}
```

In Discord, the user submits `/relay_link code:0123456789ABCDEF`. The calculator
receives a candidate, displays the name **and ID**, and asks the user to confirm:

```json
{"type":"link_candidate","discord_id":"123456789","name":"Alice"}
{"op":"link_confirm","id":"confirm1","discord_id":"123456789"}
```

Confirm only after the user explicitly accepts that displayed account. To cancel,
disconnect or use `logout`. The original link code cannot be claimed twice.
Successful confirmation, or an already-linked OIDC login, returns:

```json
{"type":"authenticated","id":"confirm1","token":"opaque-relay-session-token","discord_id":"123456789","expires_at":2000000000}
```

`expires_at` is Unix time. Store the token as a secret. Tokens issued by the
implementation are 43 URL-safe characters. Reconnect before expiry with:

```json
{"op":"resume","id":"resume1","token":"opaque-relay-session-token"}
```

The response is `authenticated` with a replacement token. Replace the saved
token immediately; the old one is invalid. No server/channel selection is resumed.
If invalid/expired (including after a server restart), start a new connection
and device login. A new login/resume disconnects any existing client for that user.

```json
{"op":"logout","id":"logout1"}
{"type":"logged_out","id":"logout1"}
```

Erase the saved credential and reconnect for another login. Logout cancels
pending login and revokes an authenticated session. The connection then closes.

## Server and channel selection

| Request | Responses |
| --- | --- |
| `{"op":"guilds","id":"g1","offset":0}` | `guilds_begin`, up to 24 `guild` items (`guild_id`, `name`), `guilds_end` (`next_offset`). |
| `{"op":"select_guild","id":"g2","guild_id":"100"}` | `selected_guild` with `guild_id`; clear channels/chat immediately. |
| `{"op":"channels","id":"c1","offset":0}` | `channels_begin`, up to 24 `channel` items (`guild_id`, `channel_id`, `name`, `can_send`, `can_history`), `channels_end` (`next_offset`). |
| `{"op":"select_channel","id":"c2","channel_id":"200"}` | `selected_channel` with `guild_id` and `channel_id`; clear chat and optionally fetch history. |

Omit `offset` for zero. `next_offset: null` ends the list. Names may repeat and
are limited to 80 characters; only IDs identify selections. Lists are snapshots:
on `channels_changed`, refresh from offset zero. Permission checks are repeated
when an operation runs, even if earlier list items reported access.

Only one server and one channel are active per user. Channels from another
server cannot be selected. No messages are delivered until a channel is selected.

## Messages

```json
{"op":"send","id":"s1","text":"Hello from my calculator!"}
{"type":"sent","id":"s1","message_id":"300","guild_id":"100","channel_id":"200"}
```

Text must contain 1–512 characters, include non-whitespace content, and contain
no control characters or newlines. `sent` acknowledges Discord acceptance;
display the gateway `message` event as the chat echo. Failed sends return an
error, not a success echo. Request IDs do not deduplicate retries.

Live events:

```json
{"type":"message","guild_id":"100","channel_id":"200","message_id":"300","author_id":"123","author":"Alice","text":"hello","truncated":false,"attachments":0}
```

Multiline Discord text is flattened for display. Longer text is truncated to
512 characters. Attachments are counted, not downloaded. Merge/deduplicate by
`message_id` because history and live events can overlap. Bot-authored relay
messages include attribution in their text; their `author_id` remains the bot's ID.

```json
{"op":"history","id":"h1","limit":20}
```

`limit` is 1–50 (default 20). An optional decimal-string `before` message ID
requests older messages in the selected channel. Responses are `history_begin`
with `channel_id`, then zero or more chronological `message` frames carrying
the request ID and `history: true`, followed by `history_end` with `channel_id`
and `before`. `before: null` means no next page was indicated; a full page may
yield a cursor whose following page is empty. Both actors need history permission.

`message_changed` and `message_deleted` events include `guild_id`, `channel_id`,
and `message_id`. Refresh history for an edit notification if permitted; remove
a deleted message from the displayed transcript. Edits do not contain new text.

## State changes and errors

`{"type":"reset","reason":"access_changed"}` clears server/channel selection.
Erase the view and discard pending content requests; refresh mutual servers
before selecting again. This occurs on permission loss, unavailable guilds,
gateway disconnection, or an expired session detected during delivery.
Queued content is dropped when resetting. Already transmitted bytes cannot be recalled.

`{"type":"channels_changed","guild_id":"100"}` requests a channel-list refresh
without clearing a still-permitted selection.

```json
{"op":"ping","id":"p1"}
{"type":"pong","id":"p1"}
{"type":"error","id":"s1","code":"access_denied"}
```

Ping does not extend session or login expiry. Common errors include
`authentication_required`, `invalid_session`, `session_expired`, `link_expired`,
`link_mismatch`, `already_linked`, `login_already_started`, `server_busy`,
`guild_unavailable`, `channel_unavailable`, `access_denied`, `discord_unavailable`,
`invalid_id`, `invalid_text`, `invalid_limit`, `invalid_offset`, `rate_limited`,
and `unknown_operation`. Provider failures include `provider_unavailable`,
`provider_configuration`, `provider_response`, `device_authorization_failed`,
`access_denied`, `expired_token`, and `invalid_identity_token`.

For failed login, reconnect and start again. For lost access, refresh lists. For
rate limiting, wait before retrying. For expired credentials, erase the token
and log in again. A send that loses its acknowledgement may already have been
posted; do not automatically resend it. On any transport loss, erase the visible
server/channel state before reconnecting.
