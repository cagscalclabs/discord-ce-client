# Calculator client

The calculator speaks [relay protocol v2](relay/PROTOCOL.md) over TLS and uses a
purple/black interface with a channel list on the left and chat on the right.

## Connect and log in

The setup screen follows the `lwip-ce/examples/irc_chat` input conventions:

- **Server / IP / URL:** enter a hostname or IPv4 address. Port **8443** is the
  default; override it with `relay.example:9443` or `192.0.2.4:9443`.
  `tls://relay.example:9443` and `https://relay.example:9443/` are also accepted.
  Both prefixes select the TLS relay transport, not an HTTP request. Paths,
  credentials in URLs, plaintext schemes, and IPv6 literals are not supported.
- **Username:** a local profile label shown in the title bar. Authentication
  establishes the real Discord account; this field cannot impersonate another
  Discord member or change the bot's outgoing attribution.
- **Up/Down** changes setup fields. **Enter** advances from target to username,
  then connects. **Alpha** cycles `abc`, `ABC`, `123`; **X,T,theta,n** shifts the
  next character to uppercase. **Del** backspaces. **Clear/Mode** exits setup.

On first connection, the client displays the provider URL and device code. Use
a phone/computer to approve login. If needed, submit the separate link code
using `/relay_link` in Discord. The calculator then shows the resulting account
name and ID: **Enter** explicitly confirms it, **Clear** cancels. Long login
screens scroll with **Up/Down**.

After authentication, choose a mutual Discord server, then a channel. The client
waits for each relay acknowledgement before changing its active selection.

The `DISCRD` AppVar stores the target, profile label, and opaque relay session
token. Changing target or username discards that saved token. Successful resume
replaces it with the relay's rotated token. Invalid saved sessions fall back to
device login. Old PIN-format configuration is not reused.

## Chat controls

| Key | Action |
| --- | --- |
| **Y=** | Focus/cancel the channel picker; refresh the channel page. |
| **Up/Down in picker** | Move the highlight without switching channels. |
| **Enter in picker** | Ask the relay to enter the highlighted channel/server. |
| **Left/Right in picker** | Previous/next page of up to 24 entries. |
| **Clear in picker** | Return to the active chat, if one exists. |
| **Window** | Open the server picker. The current subscription changes only after a new server is confirmed. |
| **Enter in chat** | Send the draft. Wait for relay acceptance; the gateway event provides the message echo. |
| **Up/Down in chat** | Scroll the buffered transcript. |
| **Trace** | Refresh the latest 20 messages, when history is permitted. |
| **Alpha / X,T,theta,n** | Cycle input mode / uppercase the next character, as in setup. |
| **Del / Clear in chat** | Backspace / clear the draft. |
| **Graph** | Log out and erase the saved relay token. |
| **Mode** | Disconnect. The unexpired saved session can be resumed later. |

After disconnecting, **Enter** returns to setup; **Mode/Clear** exits. On a lost
connection, displayed server/channel/chat state is cleared. A send without an
acknowledgement may have reached Discord and is never automatically retried.

The current channel is marked `*` in the sidebar. IDs identify channels even
when their names are duplicated or shortened for display. Read-only channels
remain selectable. Permission resets clear selections and reload servers.

## Bounds

Drafts are limited to 120 ASCII characters. Incoming text uses the relay's
512-character bound; the built-in font displays non-ASCII codepoints as `?`.
The transcript keeps up to 96 wrapped rows, and history requests fetch the most
recent 20 messages. Live/history overlap is merged by message ID and ordered by
Discord snowflake; deleted messages are removed. Edit notifications trigger a
fresh history request when allowed. Attachments appear as markers.

The parser accepts bounded, flat JSON objects for this protocol, with escaped
strings and UTF-8 decoding for JSON Unicode escapes. Frames over 4096 bytes,
embedded NULs, malformed JSON, and unsupported protocol versions disconnect.
Request IDs prevent old list/selection/history responses from changing a view
after it has been reset. List pagination keeps memory usage independent of the
server's total number of channels.

## Build and test

Install the CE C toolchain and lwIP-CE consumer headers/library. By default the
build finds the IRC example helper at `../lwip-ce/examples/common/lwip_example.h`:

```sh
make
# Or point at another lwIP checkout:
make LWIP_CE=/path/to/lwip-ce RELAY_DEFAULT_HOST=relay.example RELAY_DEFAULT_PORT=8443
```

Output: `bin/DISC.8xp`. Transfer the required GraphX/FileIOC libraries and lwIP
runtime according to lwIP-CE's installation instructions. `BSSHEAP_LOW` is set
to `0xD072C6` to leave lwIP's reserved 8 KiB window untouched. Runtime client
state is allocated using `mem_request` and released on exit.

Host-side tests exercise the same client state machine with platform substitutes:

```sh
clang -std=c11 -Wall -Wextra -Werror -fsanitize=address,undefined -g \
  tests/client_test.c src/wire.c -o /tmp/discord-ce-client-test
/tmp/discord-ce-client-test
```

Compilation and these tests do not exercise the actual calculator display,
USB adapter, TLS handshake, or the registered OIDC application.

## TLS dependency status

For connection failures, the disconnect screen preserves the socket error,
whether TLS had connected, the last TLS progress message, and the first stack
error's source file, line, and extra code. Record these fields together when
reporting a failure. Diagnostic fields can be blank if the runtime does not
emit the corresponding events. Source lines must be matched to the lwIP build
installed on the calculator.

In the currently inspected consumer headers, component `6` is `ALTCP` (`TLS`
is `7`), operation `4` is receive, and application error `6` is
`LWIP_ERR_CONNECT` (`LWIP_ERR_CLOSED` is `8`). Raw error `-13` is `ERR_ABRT`:
it can result from a local TLS failure or transport abort and does not by
itself establish that the peer closed the connection.

`hs: certificate` with `handshake.c:3964 x0` in the inspected lwIP source
points to the generic fatal-alert sender, not a specific certificate failure.
Certificate parsing, date validity, hostname matching, and allocations can
fail earlier without emitting a more specific error. Check the calculator's
date/time and use the hostname covered by the relay certificate. The client
requests background SNTP; lwIP's SNTP service-ready flag means the service
has started, not that the clock has synchronized.

The client always uses lwIP's TLS socket transport and does not disable its
certificate checks. The relay certificate must match the entered target and
the runtime's supported certificate/handshake profile.

The inspected sibling lwIP checkout's `tls_recv_certificate_streamed()` can
continue when a root is missing or unsupported. Consequently, a successful
TLS connection alone is not evidence of a trusted server. That dependency's
trust enforcement needs to be resolved/verified before production credentials
are used. No changes to the external lwIP repository are included here.
