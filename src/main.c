/* Discord-CE: bounded protocol-v2 client for lwIP-CE. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "wire.h"
#ifdef DISCORD_TEST
#include "../tests/platform.h"
#else
#include <ti/getcsc.h>
#include <fileioc.h>
#include <graphx.h>
#include <lwip.h>
#include "lwip_example.h"
#endif

#ifndef RELAY_DEFAULT_HOST
#define RELAY_DEFAULT_HOST ""
#endif
#ifndef RELAY_DEFAULT_PORT
#define RELAY_DEFAULT_PORT 9443
#endif
#if RELAY_DEFAULT_PORT < 1 || RELAY_DEFAULT_PORT > 65535
#error RELAY_DEFAULT_PORT must be between 1 and 65535
#endif

#define PAGE 24
#define ID_LEN 21
#define NAME_LEN 81
#define INPUT_LEN 121
#define CHAT_COLS 28
#define CHAT_ROWS 25
#define CHAT_X 90
#define ROWS 96
#define TOKEN_LEN 44
#define TOKEN_ENTRY_MAX 32
#define FRAME_LEN 4096
#define TRACE_MAX 4
#define TRACE_LINE_LEN 72
#define COL_BG 16
#define COL_FG 17
#define COL_PANEL 18
#define COL_PURPLE 19
#define COL_MUTED 20
#define COL_ERROR 21

typedef enum { CONNECTING, LOGIN, LINK, CONFIRM, GUILDS, CHAT } stage_t;
typedef struct { char id[ID_LEN], name[NAME_LEN]; bool send, history; } entry_t;
typedef struct { char text[CHAT_COLS + 1], id[ID_LEN]; uint8_t color; } row_t;
typedef struct { char target[128]; char token[TOKEN_LEN]; } token_entry_t;
typedef struct {
    char magic[4]; uint8_t version;
    char target[128], username[32];
    char token[TOKEN_LEN]; /* runtime only — loaded from token store by target */
} saved_t;
typedef struct {
    saved_t saved;
    struct lwip_socket socket;
    bool connected, done, quit, created, authed, dirty, picker, busy, history_busy, network_wait;
    bool refresh_channels, refresh_history, send_pending, logout_pending, save_pending, initial_guilds_pending;
    bool can_send, can_history, resuming;
    stage_t stage;
    char host[128]; uint16_t port;
    char guild[ID_LEN], channel[ID_LEN], guild_name[NAME_LEN], channel_name[NAME_LEN];
    char candidate[ID_LEN], panel[1400], status[80]; unsigned panel_scroll;
    char stack_error[80], tls_step[80], failure_phase[40];
    char traceback[TRACE_MAX][TRACE_LINE_LEN];
    uint8_t traceback_count, traceback_scroll;
    uint32_t auth_started, auth_seconds, serial, page_offset, next_page, last_ping, last_rx, request_time, refresh_time, network_started;
    char auth_req[16], list_req[16], select_req[16], history_req[16], send_req[16];
    char selected[ID_LEN], selected_name[NAME_LEN]; bool selected_send, selected_history;
    entry_t entries[PAGE]; uint8_t count, cursor, top;
    row_t rows[ROWS]; unsigned row_count, scroll;
    char seen[32][ID_LEN]; unsigned seen_count, seen_next;
    char input[INPUT_LEN]; uint8_t input_mode; bool shift;
    char rx[FRAME_LEN]; size_t rx_len;
} app_t;
static app_t *g;

static void copy(char *dst, size_t cap, const char *src) { snprintf(dst, cap, "%s", src); }
static void status(const char *fmt, ...) {
    va_list args; va_start(args, fmt); vsnprintf(g->status, sizeof(g->status), fmt, args); va_end(args); g->dirty = true;
}
/* Profile AppVar (DISCRD): magic[4] + version(1) + username[32]. */
static void save(void) {
    uint8_t file = ti_Open("DISCRD", "r+");
    if (!file) file = ti_Open("DISCRD", "w");
    if (!file) { status("Could not save profile"); return; }
    ti_Rewind(file);
    ti_Write(g->saved.magic, 4, 1, file);
    ti_Write(&g->saved.version, 1, 1, file);
    ti_Write(g->saved.username, sizeof(g->saved.username), 1, file);
    ti_SetArchiveStatus(true, file);
    ti_Close(file);
}
/* Token AppVar (DISCTK): flat array of token_entry_t, one per relay target.
 * save_token() upserts by target; load_token() looks up by current target. */
static void save_token(void) {
    if (!g->saved.token[0] || !g->saved.target[0]) return;
    token_entry_t e;
    uint8_t file = ti_Open("DISCTK", "r+");
    if (!file) {
        file = ti_Open("DISCTK", "w");
        if (!file) { status("Token save failed"); return; }
        uint8_t zero = 0; ti_Write(&zero, 1, 1, file);
        ti_Close(file);
        file = ti_Open("DISCTK", "r+");
        if (!file) { status("Token save failed (r+)"); return; }
    }
    uint8_t count = 0;
    ti_Rewind(file); ti_Read(&count, 1, 1, file);
    if (count > TOKEN_ENTRY_MAX) count = TOKEN_ENTRY_MAX;
    /* Scan for existing entry with matching target. */
    for (uint8_t i = 0; i < count; ++i) {
        uint16_t pos = ti_Tell(file);
        if (ti_Read(&e, sizeof(e), 1, file) != 1) break;
        if (!memchr(e.target, 0, sizeof(e.target)) || !memchr(e.token, 0, sizeof(e.token))) continue;
        if (!strcmp(e.target, g->saved.target)) {
            /* Overwrite just the token field in-place. */
            copy(e.token, sizeof(e.token), g->saved.token);
            ti_Seek(pos, SEEK_SET, file);
            ti_Write(&e, sizeof(e), 1, file);
            ti_SetArchiveStatus(true, file); ti_Close(file); return;
        }
    }
    /* Not found: append if under the cap; evict entry 0 (oldest) if full. */
    if (count < TOKEN_ENTRY_MAX) {
        copy(e.target, sizeof(e.target), g->saved.target);
        copy(e.token, sizeof(e.token), g->saved.token);
        ti_Write(&e, sizeof(e), 1, file);
        ++count; ti_Rewind(file); ti_Write(&count, 1, 1, file);
    }
    ti_SetArchiveStatus(true, file); ti_Close(file);
}
static void load_token(void) {
    g->saved.token[0] = 0;
    uint8_t file = ti_Open("DISCTK", "r");
    if (!file) return;
    uint8_t count = 0;
    ti_Read(&count, 1, 1, file);
    if (count > TOKEN_ENTRY_MAX) count = TOKEN_ENTRY_MAX;
    for (uint8_t i = 0; i < count; ++i) {
        token_entry_t e;
        if (ti_Read(&e, sizeof(e), 1, file) != 1) break;
        if (!memchr(e.target, 0, sizeof(e.target)) || !memchr(e.token, 0, sizeof(e.token))) continue;
        if (!strcmp(e.target, g->saved.target)) {
            copy(g->saved.token, sizeof(g->saved.token), e.token);
            break;
        }
    }
    ti_Close(file);
}
static bool token_valid(const char *s) {
    if (strlen(s) != 43) return false;
    for (; *s; ++s) if (!((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z') ||
        (*s >= '0' && *s <= '9') || *s == '_' || *s == '-')) return false;
    return true;
}
static void load(void) {
    memset(&g->saved, 0, sizeof(g->saved));
    uint8_t file = ti_Open("DISCRD", "r");
    if (file) {
        char magic[4]; uint8_t version = 0;
        if (ti_Read(magic, 4, 1, file) == 1 && !memcmp(magic, "DSC4", 4) &&
            ti_Read(&version, 1, 1, file) == 1 && version == 4 &&
            ti_Read(g->saved.username, sizeof(g->saved.username), 1, file) == 1 &&
            memchr(g->saved.username, 0, sizeof(g->saved.username)))
            memcpy(g->saved.magic, "DSC4", 4), g->saved.version = 4;
        else memset(&g->saved, 0, sizeof(g->saved));
        ti_Close(file);
    }
    memcpy(g->saved.magic, "DSC4", 4); g->saved.version = 4;
    if (!g->saved.target[0]) copy(g->saved.target, sizeof(g->saved.target), RELAY_DEFAULT_HOST);
    if (!g->saved.username[0]) copy(g->saved.username, sizeof(g->saved.username), "DiscordCE");
    load_token();
    if (!token_valid(g->saved.token)) g->saved.token[0] = 0;
}

static void clear_chat(void) {
    g->row_count = g->scroll = g->seen_count = g->seen_next = 0;
    g->history_busy = g->refresh_history = false; g->history_req[0] = 0;
    g->input[0] = 0; g->send_pending = false; g->send_req[0] = 0; g->dirty = true;
}
static void clear_selection(void) {
    clear_chat(); g->guild[0] = g->channel[0] = g->candidate[0] = 0;
    g->count = g->cursor = g->top = 0; g->busy = false;
    g->list_req[0] = g->select_req[0] = 0;
    g->can_send = g->can_history = false; g->refresh_channels = false;
}
static void fail(const char *message) {
    g->done = true; g->connected = false; clear_selection(); status("%s", message);
}
/* One '?' per non-ASCII codepoint; protocol strings themselves retain UTF-8. */
static void display_ascii(char *dst, size_t cap, const char *src) {
    size_t n = 0;
    while (*src && n + 1 < cap) {
        unsigned char c = (unsigned char)*src++;
        if (c < 128) dst[n++] = c >= 32 && c != 127 ? (char)c : ' ';
        else { dst[n++] = '?'; while (((unsigned char)*src & 0xC0) == 0x80) ++src; }
    }
    dst[n] = 0;
}
static void add_row(const char *text, const char *id, uint8_t color) {
    unsigned pos = g->row_count;
    /* Snowflakes sort by decimal length, then lexically, without 64-bit arithmetic. */
    for (unsigned i = 0; *id && i < g->row_count; ++i) {
        const char *other = g->rows[i].id;
        if (*other && (strlen(other) > strlen(id) || (strlen(other) == strlen(id) && strcmp(other, id) > 0))) { pos = i; break; }
    }
    if (g->row_count == ROWS) {
        if (!pos) return;
        memmove(g->rows, g->rows + 1, sizeof(row_t) * (ROWS - 1)); --g->row_count; --pos;
    }
    memmove(g->rows + pos + 1, g->rows + pos, sizeof(row_t) * (g->row_count - pos));
    ++g->row_count;
    row_t *row = &g->rows[pos]; copy(row->text, sizeof(row->text), text);
    copy(row->id, sizeof(row->id), id); row->color = color;
}
static void append(const char *text, const char *id, uint8_t color) {
    char row[CHAT_COLS + 1]; size_t len = strlen(text);
    do {
        size_t n = len < CHAT_COLS ? len : CHAT_COLS;
        memcpy(row, text, n); row[n] = 0; add_row(row, id, color);
        text += n; len -= n;
    } while (len);
    g->scroll = 0; g->dirty = true;
}
static void delete_message(const char *id) {
    unsigned out = 0;
    for (unsigned i = 0; i < g->row_count; ++i) if (strcmp(g->rows[i].id, id)) g->rows[out++] = g->rows[i];
    g->row_count = out; g->scroll = 0; g->dirty = true;
}
static bool seen(const char *id) {
    for (unsigned i = 0; i < g->row_count; ++i) if (!strcmp(g->rows[i].id, id)) return true;
    for (unsigned i = 0; i < g->seen_count; ++i) if (!strcmp(g->seen[i], id)) return true;
    copy(g->seen[g->seen_next], ID_LEN, id); g->seen_next = (g->seen_next + 1) % 32;
    if (g->seen_count < 32) ++g->seen_count; return false;
}

static bool request(char *tracker, const char *op, const char *extra) {
    /* frame[400] on the stack overflows the ez80 stack during deep call chains;
     * allocate from the lwIP heap instead. */
    char *frame = mem_malloc(400);
    if (!frame)
    {
        status("Out of memory");
        return false;
    }
    char id[16];
    snprintf(id, sizeof(id), "r%lu", (unsigned long)++g->serial);
    int n = snprintf(frame, 400, "{\"op\":\"%s\",\"id\":\"%s\"%s}\n", op, id, extra ? extra : "");
    if (n < 0 || n >= 400)
    {
        mem_free(frame);
        status("Request too long");
        return false;
    }
    if (!g->connected || lwip_socket_write(&g->socket, (const uint8_t *)frame, (size_t)n) != LWIP_OK) {
        mem_free(frame);
        fail("Connection lost; send outcome unknown");
        return false;
    }
    mem_free(frame);
    if (tracker) { copy(tracker, 16, id); g->request_time = lwip_now_ms(); }
    return true;
}
static void login(void) {
    char extra[70]; g->stage = LOGIN; g->resuming = token_valid(g->saved.token);
    if (g->resuming) {
        snprintf(extra, sizeof(extra), ",\"token\":\"%s\"", g->saved.token);
        request(g->auth_req, "resume", extra); status("Resuming saved session...");
    } else { request(g->auth_req, "login", NULL); status("Requesting browser login..."); }
}
static void list_page(uint32_t offset) {
    char extra[40];
    if (g->busy) return;
    snprintf(extra, sizeof(extra), ",\"offset\":%lu", (unsigned long)offset);
    if (request(g->list_req, g->stage == GUILDS ? "guilds" : "channels", extra)) {
        g->page_offset = offset; g->next_page = 0; g->busy = true;
        g->count = g->cursor = g->top = 0; status("Loading list...");
    }
}
static void history(void) {
    if (g->history_busy || !g->channel[0] || !g->can_history || g->busy) return;
    if (request(g->history_req, "history", ",\"limit\":20")) {
        g->row_count = g->scroll = g->seen_count = g->seen_next = 0;
        g->history_busy = true; g->refresh_history = false; status("Loading history...");
    }
}
static void choose(void) {
    char extra[60];
    if (g->busy || !g->count || g->cursor >= g->count) return;
    entry_t *entry = &g->entries[g->cursor];
    copy(g->selected, sizeof(g->selected), entry->id); copy(g->selected_name, sizeof(g->selected_name), entry->name);
    g->selected_send = entry->send; g->selected_history = entry->history;
    snprintf(extra, sizeof(extra), ",\"%s_id\":\"%s\"", g->stage == GUILDS ? "guild" : "channel", entry->id);
    if (request(g->select_req, g->stage == GUILDS ? "select_guild" : "select_channel", extra)) {
        g->busy = true; status("Waiting for selection...");
    }
}
static bool matches(const char *a, const char *b) { return *a && *b && !strcmp(a, b); }
typedef struct {
    wire_object object;
    uint32_t number;
    char name[NAME_LEN];    /* link_candidate display name */
    char author[NAME_LEN];  /* message author */
    char text[513];         /* message text */
    char message[620];      /* formatted message line */
} rx_buf_t;
static void received(char *line) {
    rx_buf_t *r = mem_malloc(sizeof(rx_buf_t));
    if (!r) { fail("Out of memory"); return; }
    if (!wire_parse(&r->object, line)) { mem_free(r); fail("Invalid relay frame"); return; }
    g->last_rx = lwip_now_ms();
    const char *type = wire_string(&r->object, "type"), *id = wire_string(&r->object, "id");
    const char *guild = wire_string(&r->object, "guild_id"), *channel = wire_string(&r->object, "channel_id");
    bool auth_response = matches(id, g->auth_req), list_response = matches(id, g->list_req);
    if (!strcmp(type, "hello")) {
        if (g->stage != CONNECTING || !wire_uint(&r->object, "version", &r->number) || r->number != 2) { mem_free(r); fail("Relay protocol mismatch"); return; }
        mem_free(r); login(); return;
    }
    if (!strcmp(type, "device") && auth_response) {
        const char *uri = wire_string(&r->object, "verification_uri"), *code = wire_string(&r->object, "user_code");
        if (strncmp(uri, "https://", 8) || strlen(uri) > 1024 || strlen(code) > 128 || !*code) { mem_free(r); fail("Invalid login response"); return; }
        snprintf(g->panel, sizeof(g->panel), "Open on phone/computer:\n%s\n\nEnter this code:\n%s\n\nApprove login in browser.\nUp/Down scroll this screen.", uri, code);
        g->panel_scroll = 0; g->stage = LOGIN; status("Waiting for browser approval");
        if (wire_uint(&r->object, "expires_in", &r->number)) { g->auth_started = lwip_now_ms(); g->auth_seconds = r->number; }
    } else if (!strcmp(type, "link_required") && auth_response) {
        const char *code = wire_string(&r->object, "code");
        if (strlen(code) != 16) { mem_free(r); fail("Invalid linking code"); return; }
        snprintf(g->panel, sizeof(g->panel), "Link your Discord account:\n\nIn a server with this bot, run\n/relay_link code:%s\n\nThen confirm the account here.\nOnly use a code from YOUR calc.", code);
        g->panel_scroll = 0; g->stage = LINK; status("Waiting for Discord link");
        if (wire_uint(&r->object, "expires_in", &r->number)) { g->auth_started = lwip_now_ms(); g->auth_seconds = r->number; }
    } else if (!strcmp(type, "link_candidate") && g->stage == LINK) {
        const char *user_id = wire_string(&r->object, "discord_id");
        if (!wire_id(user_id)) { mem_free(r); fail("Invalid linked account"); return; }
        copy(g->candidate, sizeof(g->candidate), user_id); display_ascii(r->name, sizeof(r->name), wire_string(&r->object, "name"));
        snprintf(g->panel, sizeof(g->panel), "Confirm YOUR Discord account:\n\n%s\nID: %s\n\nENTER: link this account\nCLEAR: cancel and disconnect", r->name, user_id);
        g->stage = CONFIRM; g->panel_scroll = 0; status("Check name and account ID");
    } else if (!strcmp(type, "authenticated") && auth_response) {
        const char *token = wire_string(&r->object, "token");
        if (!token_valid(token) || !wire_id(wire_string(&r->object, "discord_id"))) { mem_free(r); fail("Invalid session response"); return; }
        copy(g->saved.token, sizeof(g->saved.token), token);
        save_token(); /* mem_malloc pointers are safe across FileIOC; write immediately */
        g->authed = true;
        g->auth_seconds = 0;
        g->panel[0] = 0;
        clear_selection();
        g->stage = GUILDS;
        g->initial_guilds_pending = true;
        status("Login confirmed; loading servers...");
    } else if ((!strcmp(type, "guild") || !strcmp(type, "channel")) && list_response) {
        bool is_guild = g->stage == GUILDS;
        const char *entry_id = is_guild ? guild : channel;
        if ((!is_guild && (!matches(guild, g->guild) || strcmp(type, "channel"))) ||
            (is_guild && strcmp(type, "guild")) || !wire_id(entry_id) || g->count == PAGE) { mem_free(r); fail("Invalid channel list"); return; }
        entry_t *entry = &g->entries[g->count++]; copy(entry->id, sizeof(entry->id), entry_id);
        display_ascii(entry->name, sizeof(entry->name), wire_string(&r->object, "name"));
        entry->send = wire_bool(&r->object, "can_send"); entry->history = wire_bool(&r->object, "can_history");
        if (matches(entry_id, g->channel)) { g->can_send = entry->send; g->can_history = entry->history; }
        g->dirty = true;
    } else if ((!strcmp(type, "guilds_end") || !strcmp(type, "channels_end")) && list_response) {
        g->next_page = 0;
        if (wire_uint(&r->object, "next_offset", &r->number) && r->number > g->page_offset && r->number <= 100000UL) g->next_page = r->number;
        g->busy = false; g->list_req[0] = 0;
        status(!g->count ? "No accessible entries; Y= reload" :
               (g->picker || g->stage == GUILDS) ? "Up/Down, Enter to select" : "Enter sends; Y= channels");
    } else if (!strcmp(type, "selected_guild") && matches(id, g->select_req)) {
        if (!matches(guild, g->selected)) { mem_free(r); fail("Server selection mismatch"); return; }
        clear_chat(); copy(g->guild, sizeof(g->guild), guild); copy(g->guild_name, sizeof(g->guild_name), g->selected_name);
        g->channel[0] = 0; g->busy = false; g->select_req[0] = 0; g->stage = CHAT; g->picker = true; list_page(0);
    } else if (!strcmp(type, "selected_channel") && matches(id, g->select_req)) {
        if (!matches(channel, g->selected) || !matches(guild, g->guild)) { mem_free(r); fail("Channel selection mismatch"); return; }
        clear_chat(); copy(g->channel, sizeof(g->channel), channel); copy(g->channel_name, sizeof(g->channel_name), g->selected_name);
        g->can_send = g->selected_send; g->can_history = g->selected_history;
        g->busy = false; g->select_req[0] = 0; g->picker = false;
        status(g->can_send ? "Enter sends; Y= channels" : "Read-only channel; Y= channels"); history();
    } else if (!strcmp(type, "history_begin") && matches(id, g->history_req) && matches(channel, g->channel)) {
        /* Keep live messages received while HTTP history was in flight. */
        g->dirty = true;
    } else if (!strcmp(type, "history_end") && matches(id, g->history_req) && matches(channel, g->channel)) {
        g->history_busy = false; g->history_req[0] = 0; status("Enter sends; Y= channels");
    } else if (!strcmp(type, "message") && g->authed && matches(guild, g->guild) && matches(channel, g->channel)) {
        if (*id && !matches(id, g->history_req)) { mem_free(r); return; }
        const char *message_id = wire_string(&r->object, "message_id");
        if (!wire_id(message_id) || seen(message_id)) { mem_free(r); return; }
        display_ascii(r->author, sizeof(r->author), wire_string(&r->object, "author"));
        display_ascii(r->text, sizeof(r->text), wire_string(&r->object, "text"));
        snprintf(r->message, sizeof(r->message), "<%s> %s%s", r->author, r->text, wire_bool(&r->object, "truncated") ? "..." : "");
        append(r->message, message_id, COL_FG);
        if (wire_uint(&r->object, "attachments", &r->number) && r->number) append("[attachment]", message_id, COL_MUTED);
    } else if ((!strcmp(type, "message_deleted") || !strcmp(type, "message_changed")) &&
               g->authed && matches(guild, g->guild) && matches(channel, g->channel)) {
        const char *message_id = wire_string(&r->object, "message_id");
        if (!wire_id(message_id)) { mem_free(r); return; }
        delete_message(message_id); (void)seen(message_id);
        if (!strcmp(type, "message_changed")) {
            g->refresh_history = g->can_history; status(g->can_history ? "Message edited; refreshing..." : "Edited message removed");
        }
    } else if (!strcmp(type, "sent") && matches(id, g->send_req)) {
        g->send_pending = false; g->input[0] = 0; g->send_req[0] = 0; status("Sent");
    } else if (!strcmp(type, "reset") && g->authed) {
        clear_selection(); g->stage = GUILDS; list_page(0); status("Access changed; select server");
    } else if (!strcmp(type, "channels_changed") && matches(guild, g->guild)) {
        g->refresh_channels = true;
    } else if (!strcmp(type, "logged_out")) {
        g->saved.token[0] = 0;
        g->save_pending = true;
        mem_free(r); fail("Logged out"); return;
    } else if (!strcmp(type, "error")) {
        const char *code = wire_string(&r->object, "code");
        if (auth_response) {
            g->saved.token[0] = 0;
            g->save_pending = true;
            if (g->resuming && !strcmp(code, "invalid_session")) { g->resuming = false; mem_free(r); login(); return; }
            mem_free(r); fail(code); return;
        }
        if (!strcmp(code, "session_expired") || !strcmp(code, "authentication_required"))
        {
            g->saved.token[0] = 0;
            g->save_pending = true;
            mem_free(r); fail("Session expired; reconnect"); return;
        }
        if (list_response || matches(id, g->select_req)) { g->busy = false; g->list_req[0] = g->select_req[0] = 0; }
        if (matches(id, g->history_req)) { g->history_busy = false; g->history_req[0] = 0; }
        if (matches(id, g->send_req)) { g->send_pending = false; g->send_req[0] = 0; }
        status("%s", code);
    }
    mem_free(r);
}

static void feed(char c) {
    if (!c) { fail("Invalid NUL in frame"); return; }
    if (c == '\n') { g->rx[g->rx_len] = 0; received(g->rx); g->rx_len = 0; }
    else if (g->rx_len < FRAME_LEN - 1) g->rx[g->rx_len++] = c;
    else fail("Relay frame exceeds 4096 bytes");
}
static void capture_traceback(void)
{
    uint8_t count = 0;
    const struct lwip_traceback_entry *entries = lwip_get_traceback(&count);
    g->traceback_count = count > TRACE_MAX ? TRACE_MAX : count;
    g->traceback_scroll = 0;
    for (uint8_t i = 0; i < g->traceback_count; ++i)
    {
        const struct lwip_traceback_entry *e = &entries[i];
        if (e->file)
        {
            snprintf(g->traceback[i], sizeof(g->traceback[i]), "%s:%lu x%u",
                     lwip_debug_file_name(e->file), (unsigned long)e->line,
                     (unsigned)e->extra);
        }
        else
        {
            snprintf(g->traceback[i], sizeof(g->traceback[i]),
                     "socket c%u o%u r%d e%u s%u", (unsigned)e->component,
                     (unsigned)e->operation, e->raw_error,
                     (unsigned)e->mapped_error, (unsigned)e->status);
        }
    }
}
/* Keep diagnostics in memory; drawing from a stack callback disrupts the UI. */
static void stack_event(const struct lwip_event *ev)
{
    if (!g || g->done || !g->created || !ev)
        return;
    if (ev->kind == LWIP_EV_INFO && ev->module == LWIP_DBG_MOD_TLS)
        copy(g->tls_step, sizeof(g->tls_step), ev->data.msg ? ev->data.msg : "");
    if (ev->kind == LWIP_EV_ERROR)
    {
        char detail[sizeof(g->stack_error)];
        snprintf(detail, sizeof(detail), "%s:%lu x%u",
                 lwip_debug_file_name(LWIP_EVENT_CODE_FILE(ev->data.code.loc)),
                 (unsigned long)LWIP_EVENT_CODE_LINE(ev->data.code.loc),
                 (unsigned)ev->data.code.extra);
        /* ARP/DHCP can emit benign diagnostics during a handshake. Retain a
         * system error only until a TLS error gives the relevant cause. */
        if (ev->module == LWIP_DBG_MOD_TLS || !g->stack_error[0])
            copy(g->stack_error, sizeof(g->stack_error), detail);
    }
}
static void event(struct lwip_socket *socket, lwip_socket_event_type_t type, const void *data, void *arg) {
    (void)socket; (void)arg;
    /* Teardown can enqueue more events; preserve the original failure. */
    if (g->done)
        return;
    if (type == LWIP_SOCKET_EV_ERROR)
    {
        const lwip_socket_error_data_t *e = data;
        copy(g->failure_phase, sizeof(g->failure_phase), !g->connected ? "Before TLS connected" : g->stage == CONNECTING ? "Waiting for relay hello"
                                                                                                                         : "Relay session");
        if (e)
            status("Net err c%u o%u r%d e%u", (unsigned)e->component, (unsigned)e->operation, e->raw_error, (unsigned)e->err);
        else
            status("Network error; no details");
        capture_traceback();
        g->done = true;
        g->connected = false;
        clear_selection();
        return;
    }
    if (type == LWIP_SOCKET_EV_STATE_CHANGE) {
        const lwip_socket_state_data_t *state = data;
        if (state->current == LWIP_STATUS_CONNECTED) { g->connected = true; status("TLS connected; waiting for relay"); }
        else if (state->current == LWIP_STATUS_CLOSED || state->current == LWIP_STATUS_RESET)
        {
            copy(g->failure_phase, sizeof(g->failure_phase), "Relay session closed");
            capture_traceback();
            fail("Disconnected; reconnect from setup");
        }
    }
}

static void text(int x, int y, uint8_t fg, uint8_t bg, const char *value, unsigned cols) {
    char clipped[41]; if (cols > 40) cols = 40;
    snprintf(clipped, sizeof(clipped), "%.*s", (int)cols, value);
    gfx_SetTextFGColor(fg); gfx_SetTextBGColor(bg); gfx_PrintStringXY(clipped, x, y);
}
static void fill(int x, int y, int w, int h, uint8_t color) {
    gfx_SetColor(color); gfx_FillRectangle(x, y, w, h);
}
static void panel(void) {
    /* Preserve URL/code line breaks and offer scrolling rather than truncation. */
    const char *p = g->panel; unsigned row = 0, shown = 0;
    while (*p && shown < 23) {
        char line[40]; unsigned n = 0;
        while (*p && *p != '\n' && n < 39) line[n++] = *p++;
        if (*p == '\n') ++p; line[n] = 0;
        if (row++ >= g->panel_scroll) { text(2, 24 + shown * 8, COL_FG, COL_BG, line, 39); ++shown; }
    }
}
static void render(void) {
    char line[80]; gfx_FillScreen(COL_BG);
    fill(0, 0, 320, 16, COL_PURPLE);
    snprintf(line, sizeof(line), "Discord %.14s | %.16s", g->saved.username, g->guild_name);
    text(2, 4, COL_FG, COL_PURPLE, line, 39);
    if (g->done)
    {
        text(4, 40, COL_ERROR, COL_BG, g->status, 39);
        text(4, 56, COL_FG, COL_BG, g->failure_phase, 39);
        snprintf(line, sizeof(line), "TLS: %.31s  Traceback (newest)", g->tls_step);
        text(4, 72, COL_MUTED, COL_BG, line, 39);
        if (!g->traceback_count)
            text(4, 88, COL_FG, COL_BG, "No traceback entries captured", 39);
        for (uint8_t row = 0; row < 17 && row + g->traceback_scroll < g->traceback_count; ++row)
            text(4, 88 + row * 8, COL_FG, COL_BG,
                 g->traceback[row + g->traceback_scroll], 39);
    }
    else if (g->stage <= CONFIRM) panel();
    else {
        fill(0, 16, CHAT_X - 2, 208, COL_PANEL);
        text(2, 18, COL_FG, COL_PANEL, g->stage == GUILDS ? "Servers" : "Channels", 10);
        for (unsigned i = g->top, row = 0; i < g->count && row < 22; ++i, ++row) {
            bool cursor = i == g->cursor && (g->picker || g->stage == GUILDS);
            uint8_t bg = cursor ? COL_PURPLE : COL_PANEL;
            fill(0, 28 + row * 8, CHAT_X - 2, 8, bg);
            snprintf(line, sizeof(line), "%c%.9s", matches(g->entries[i].id, g->channel) ? '*' : ' ', g->entries[i].name);
            text(0, 28 + row * 8, COL_FG, bg, line, 10);
        }
        text(0, 208, COL_MUTED, COL_PANEL, "<> pages", 10);
        text(CHAT_X, 18, COL_MUTED, COL_BG, g->stage == GUILDS ? "Choose a Discord server" : g->channel_name, CHAT_COLS);
        unsigned end = g->row_count > g->scroll ? g->row_count - g->scroll : 0;
        unsigned start = end > CHAT_ROWS - 2 ? end - (CHAT_ROWS - 2) : 0;
        for (unsigned i = start; i < end; ++i) text(CHAT_X, 30 + (i - start) * 8, g->rows[i].color, COL_BG, g->rows[i].text, CHAT_COLS);
        if (g->stage == CHAT && !g->picker) {
            size_t len = strlen(g->input); const char *tail = g->input + (len > CHAT_COLS - 2 ? len - (CHAT_COLS - 2) : 0);
            snprintf(line, sizeof(line), "%c %s", g->shift || g->input_mode == 1 ? 'A' : g->input_mode == 2 ? '0' : 'a', tail);
            fill(CHAT_X, 216, 230, 8, COL_PANEL); text(CHAT_X, 216, COL_FG, COL_PANEL, line, CHAT_COLS);
        }
    }
    fill(0, 224, 320, 16, COL_PANEL); text(2, 225, COL_FG, COL_PANEL, g->status, 39);
    text(2, 233, COL_MUTED, COL_PANEL,
         g->done ? "Up/Down: trace Enter: setup Mode: exit" : "Y=:ch Window:srv Mode:disc Clear:quit", 39);
    gfx_BlitBuffer(); g->dirty = false;
}
static void palette(void) {
    static const uint16_t colors[] = { gfx_RGBTo1555(12, 10, 20), gfx_RGBTo1555(235, 233, 245),
        gfx_RGBTo1555(28, 23, 43), gfx_RGBTo1555(102, 65, 180), gfx_RGBTo1555(175, 158, 211), gfx_RGBTo1555(255, 105, 120) };
    gfx_SetPalette(colors, sizeof(colors), COL_BG);
    gfx_SetMonospaceFont(8); gfx_SetTextScale(1, 1);
}
static char input_char(uint8_t key) {
    if (key == sk_Alpha) { g->input_mode = (g->input_mode + 1) % 3; g->shift = false; g->dirty = true; return 0; }
    if (key == sk_GraphVar) { g->shift = true; g->dirty = true; return 0; }
    char c = key_to_char(key, g->shift ? 1 : g->input_mode);
    if (c) g->shift = false; return c;
}
static void handle_key(uint8_t key) {
    if (!key || g->logout_pending) return;
    if (key == sk_Clear && g->stage > CONFIRM) { g->done = g->quit = true; clear_selection(); status("Goodbye"); return; }
    if (key == sk_Mode) { g->done = true; clear_selection(); status("Disconnected"); return; }
    if (key == sk_Graph && g->authed) {
        g->saved.token[0] = 0;
        g->save_pending = true;
        g->logout_pending = true;
        request(NULL, "logout", NULL);
        status("Logging out...");
        return;
    }
    if (g->stage <= CONFIRM) {
        if (key == sk_Clear) { fail("Login cancelled"); return; }
        if (key == sk_Up && g->panel_scroll) --g->panel_scroll;
        if (key == sk_Down && g->panel_scroll < 40) ++g->panel_scroll;
        if (g->stage == CONFIRM && key == sk_Enter && g->candidate[0]) {
            char extra[60]; snprintf(extra, sizeof(extra), ",\"discord_id\":\"%s\"", g->candidate);
            request(g->auth_req, "link_confirm", extra); g->candidate[0] = 0; status("Confirming account...");
        }
        g->dirty = true; return;
    }
    if (key == sk_Window && !g->busy && !g->send_pending) {
        /* Viewing the server picker does not change the active subscription yet. */
        g->stage = GUILDS; g->picker = true; list_page(0); return;
    }
    if (key == sk_Yequ && !g->busy) {
        if (g->stage == GUILDS && !g->guild[0]) list_page(g->page_offset);
        else { g->stage = CHAT; g->picker = !g->picker || !g->channel[0]; list_page(0); }
        g->dirty = true; return;
    }
    if (g->stage == GUILDS || g->picker) {
        if (g->busy) return;
        if (key == sk_Up && g->cursor) --g->cursor;
        if (key == sk_Down && g->cursor + 1 < g->count) ++g->cursor;
        if (key == sk_Left && g->page_offset) list_page(g->page_offset >= PAGE ? g->page_offset - PAGE : 0);
        if (key == sk_Right && g->next_page) list_page(g->next_page);
        if (key == sk_Enter) choose();
        if (key == sk_Clear && g->channel[0]) { g->stage = CHAT; g->picker = false; list_page(0); }
        if (g->cursor < g->top) g->top = g->cursor;
        if (g->cursor >= g->top + 22) g->top = g->cursor - 21;
        g->dirty = true; return;
    }
    if (key == sk_Up && g->scroll + CHAT_ROWS - 2 < g->row_count) ++g->scroll;
    else if (key == sk_Down && g->scroll) --g->scroll;
    else if (key == sk_Trace) { g->refresh_history = g->can_history; }
    else if (!g->send_pending) {
        size_t len = strlen(g->input);
        if (key == sk_Del && len) g->input[len - 1] = 0;
        else if (key == sk_Enter && len) {
            if (!g->channel[0] || !g->can_send || g->busy) { status("Select a writable channel"); return; }
            char *quoted = mem_malloc(INPUT_LEN * 2 + 3);
            char *extra  = mem_malloc(INPUT_LEN * 2 + 20);
            if (!quoted || !extra) { mem_free(quoted); mem_free(extra); status("Out of memory"); return; }
            if (wire_quote(quoted, INPUT_LEN * 2 + 3, g->input)) {
                snprintf(extra, INPUT_LEN * 2 + 20, ",\"text\":%s", quoted);
                if (request(g->send_req, "send", extra)) { g->send_pending = true; status("Sending..."); }
            }
            mem_free(quoted); mem_free(extra);
        } else {
            char c = input_char(key);
            if (c && len + 1 < sizeof(g->input)) { g->input[len] = c; g->input[len + 1] = 0; }
        }
    }
    g->dirty = true;
}

static bool setup(void) {
    unsigned field = 0; bool redraw = true; char original_target[128], original_user[32];
    copy(original_target, sizeof(original_target), g->saved.target); copy(original_user, sizeof(original_user), g->saved.username);
    for (;;) {
        lwip_service_events(); uint8_t key = os_GetCSC();
        char *value = field ? g->saved.username : g->saved.target;
        size_t capacity = field ? sizeof(g->saved.username) : sizeof(g->saved.target), len = strlen(value);
        if (key == sk_Clear || key == sk_Mode) return false;
        if (key == sk_Up || key == sk_Down) field = !field;
        else if (key == sk_Del && len) value[len - 1] = 0;
        else if (key == sk_Enter) {
            if (!field) field = 1;
            else if (!wire_target(g->saved.target, g->host, sizeof(g->host), RELAY_DEFAULT_PORT, &g->port)) status("Use host:port or tls://host:port");
            else if (!g->saved.username[0]) status("Enter a local username/profile");
            else {
                save();
                if (strcmp(original_target, g->saved.target)) load_token();
                return true;
            }
        } else {
            char c = input_char(key);
            if (c && c != ' ' && len + 1 < capacity) { value[len] = c; value[len + 1] = 0; }
        }
        if (key) redraw = true;
        if (redraw) {
            gfx_FillScreen(COL_BG); fill(0, 0, 320, 16, COL_PURPLE);
            text(2, 4, COL_FG, COL_PURPLE, "Discord relay setup", 39);
            text(2, 28, COL_FG, COL_BG, field ? "  Server / IP / URL:" : "> Server / IP / URL:", 39);
            /* Long targets remain visible on up to four fixed-width lines. */
            for (unsigned i = 0; i < 4 && i * 39 < strlen(g->saved.target); ++i) text(2, 40 + i * 8, COL_FG, COL_BG, g->saved.target + i * 39, 39);
            text(2, 86, COL_FG, COL_BG, field ? "> Username (local profile):" : "  Username (local profile):", 39);
            text(2, 100, COL_FG, COL_BG, g->saved.username, 39);
            text(2, 124, COL_MUTED, COL_BG, "Discord identity is verified at login.", 39);
            text(2, 140, COL_MUTED, COL_BG, "Port 8443 unless set in target line.", 39);
            text(2, 164, COL_FG, COL_BG, "Alpha: abc/ABC/123   X,T: shift", 39);
            text(2, 180, COL_FG, COL_BG, g->shift ? "Input: ABC (once)" : g->input_mode == 0 ? "Input: abc" : g->input_mode == 1 ? "Input: ABC" : "Input: 123", 39);
            text(2, 204, COL_ERROR, COL_BG, g->status, 39);
            text(2, 224, COL_FG, COL_BG, "Enter: next/connect   Clear: exit", 39);
            gfx_BlitBuffer(); redraw = false;
        }
    }
}
static void run(void) {
    g->done = g->connected = g->authed = g->created = g->logout_pending = g->network_wait = false;
    g->panel[0] = 0; g->rx_len = 0; g->auth_seconds = 0; g->stage = CONNECTING;
    g->stack_error[0] = g->tls_step[0] = g->failure_phase[0] = 0;
    g->traceback_count = g->traceback_scroll = 0;
    clear_selection(); g->guild_name[0] = g->channel_name[0] = 0;
    lwip_error_t err = lwip_socket_create(&g->socket, LWIP_SOCKET_ALTCP_TLS, LWIP_NETIF_EXT, NULL, 45000u);
    if (err != LWIP_OK) { fail("Socket create failed"); return; } g->created = true;
    lwip_socket_on_event(&g->socket, LWIP_SOCKET_EVENTF_ALL, event, NULL);
    /* Start services on this socket's interface. Poll readiness from our own
     * loop so no callback outlives the connection during teardown. */
    err = lwip_netif_request_services(g->socket.netif,
                                      LWIP_SOCKET_SVC_DHCP | LWIP_SOCKET_SVC_DNS |
                                          LWIP_SOCKET_SVC_SNTP,
                                      45000u, NULL, NULL);
    if (err != LWIP_OK)
    {
        fail("Network service request failed");
        return;
    }
    g->network_wait = true;
    g->network_started = lwip_now_ms();
    status("Waiting for DHCP/DNS (Mode cancels)");
    render();
    while (!g->done) {
        lwip_service_events();
        uint32_t now = lwip_now_ms();
        if (g->network_wait)
        {
            if ((uint32_t)(now - g->network_started) >= 45000UL)
                fail("Network timeout");
            else if (lwip_are_services_ready(g->socket.netif,
                                             LWIP_SOCKET_SVC_DHCP | LWIP_SOCKET_SVC_DNS))
            {
                g->network_wait = false;
                status("Connecting to %.45s:%u", g->host, (unsigned)g->port);
                err = lwip_socket_connect(&g->socket, g->host, g->port);
                if (err != LWIP_OK)
                    fail("Connection failed");
                else
                    g->last_ping = g->last_rx = g->request_time = now;
            }
        }
        uint8_t bytes[128]; unsigned budget = FRAME_LEN * 2;
        while (!g->done && g->connected && lwip_socket_available(&g->socket) && budget) {
            size_t n = lwip_socket_read(&g->socket, bytes, sizeof(bytes)); if (!n) break;
            for (size_t i = 0; i < n && !g->done; ++i) feed((char)bytes[i]);
            budget = budget > n ? budget - n : 0;
        }
        /* Do not enter the TLS send path while dispatching a received frame.
         * In particular, authentication queues the first guild request here. */
        if (g->initial_guilds_pending && g->connected && !g->done)
        {
            g->initial_guilds_pending = false;
            list_page(0);
        }
        handle_key(os_GetCSC());
        now = lwip_now_ms();
        if (g->connected && !g->done && (uint32_t)(now - g->last_ping) >= 30000UL) { request(NULL, "ping", NULL); g->last_ping = now; }
        if (g->connected && (uint32_t)(now - g->last_rx) >= 90000UL) fail("Relay not responding; reconnect");
        if (g->authed && (g->busy || g->history_busy || g->send_pending) && (uint32_t)(now - g->request_time) >= 60000UL)
            fail(g->send_pending ? "No send reply; outcome unknown" : "Request timed out; reconnect");
        if (g->logout_pending && (uint32_t)(now - g->last_rx) >= 5000UL) fail("Logged out locally; connection closed");
        if (g->auth_seconds && (uint32_t)(now - g->auth_started) / 1000 >= g->auth_seconds) fail("Login expired; reconnect");
        if (g->authed && !g->busy && !g->done && (uint32_t)(now - g->refresh_time) >= 1500) {
            if (g->refresh_channels && g->stage == CHAT) { g->refresh_channels = false; list_page(g->page_offset); g->refresh_time = now; }
            else if (g->refresh_history && !g->history_busy) { history(); g->refresh_time = now; }
        }
        if (g->dirty) render();
    }
}
int main(void) {
    if (!lwip_example_stack_start()) { lwip_example_gfx_stop(); return 1; }
    g = mem_request(sizeof(*g));
    if (!g) { lwip_example_show_and_wait("Discord", "Not enough memory"); return lwip_example_finish(1); }
    memset(g, 0, sizeof(*g)); palette(); load();
    lwip_set_event_cb(stack_event);
    while (!g->quit && setup()) {
        run();
        if (g->created) { lwip_socket_destroy(&g->socket); g->created = false; }
        if (g->save_pending) { save_token(); g->save_pending = false; }
        if (g->quit) break;
        clear_selection(); g->done = true; render();
        uint8_t key = 0;
        while (key != sk_Enter && key != sk_Mode && key != sk_Clear)
        {
            lwip_service_events();
            key = os_GetCSC();
            if (key == sk_Up && g->traceback_scroll)
            {
                --g->traceback_scroll;
                render();
            }
            if (key == sk_Down && g->traceback_scroll + 17 < g->traceback_count)
            {
                ++g->traceback_scroll;
                render();
            }
        }
        if (key != sk_Enter) break;
        g->status[0] = 0;
    }
    /* Tokens are saved on authentication, not on exit after an edited profile. */
    lwip_set_event_cb(NULL);
    memset(g, 0, sizeof(*g)); mem_release(g); g = NULL;
    return lwip_example_finish(0);
}
