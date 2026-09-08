# discord-ce

Discord-CE is intended to be a thin Discord client for use on the TI-84+ CE graphing calculator via lwIP-CE, WiTi, or any other flavor of networking.

**Note** Discord's Terms of Service prohibit true custom clients that log in as a user. This means this client must send requests to a Discord bot, which manages user-identity locally, before pushing/pulling content to a server.

Pull Message => Bot with read message history permission
Push Message => Webhook from calc (or bot)
Perhaps Oauth2 for authentication?

Current project layout:
src/ => Calculator side
relay/ => Bot code

*Code mostly written by Claude Sonnet so, a review for correctness/efficiency is in order.*