#define DISCORD_TEST
#define main calculator_main
#include "../src/main.c"
#undef main
#include <assert.h>

static void reset(void) {
    static app_t app;
    memset(&app, 0, sizeof(app)); g = &app; g->connected = true;
    memcpy(g->saved.magic, "DSC3", 4); g->saved.version = 3;
    test_tx[0] = 0; test_key_pos = 0; test_time = 1000;
}
static void rx(const char *s) { char buffer[4096]; copy(buffer, sizeof(buffer), s); received(buffer); }
static void active(void) {
    reset(); g->stage = CHAT; g->authed = true; g->can_send = g->can_history = true;
    copy(g->guild, ID_LEN, "10"); copy(g->channel, ID_LEN, "20");
}
static void test_wire(void) {
    char good[] = "{\"type\":\"message\",\"text\":\"quote: \\\" hi\\n\\u00e9\\ud83d\\ude00\",\"n\":4294967295,\"can_send\":true,\"next_offset\":null}";
    wire_object obj; uint32_t n;
    assert(wire_parse(&obj, good));
    assert(strstr(wire_string(&obj, "text"), "quote: \" hi\n\xc3\xa9\xf0\x9f\x98\x80"));
    assert(wire_uint(&obj, "n", &n) && n == UINT32_MAX);
    assert(!wire_uint(&obj, "next_offset", &n)); assert(wire_bool(&obj, "can_send"));
    const char *bad[] = {"", "{", "[]", "{\"x\":1,}", "{\"x\":1 \"y\":2}", "{\"x\":1,\"x\":2}",
        "{\"x\":01}", "{\"x\":\"\\u0000\"}", "{\"x\":\"\\ud800\"}", "{\"x\":\"\\udc00\"}", "{\"x\":{}}", "{} garbage"};
    for (unsigned i = 0; i < sizeof(bad)/sizeof(*bad); ++i) { char buf[100]; copy(buf, sizeof(buf), bad[i]); assert(!wire_parse(&obj, buf)); }
    char quoted[100]; assert(wire_quote(quoted, sizeof(quoted), "a\"b\\c")); assert(!strcmp(quoted, "\"a\\\"b\\\\c\""));
    assert(!wire_quote(quoted, 4, "abcdef")); assert(!wire_quote(quoted, sizeof(quoted), "bad\nframe"));
    assert(wire_id("18446744073709551615")); assert(!wire_id("18446744073709551616")); assert(!wire_id("01"));
}
static void test_targets(void) {
    char host[128]; uint16_t port;
    assert(wire_target("192.0.2.4", host, sizeof(host), 8443, &port) && port == 8443);
    assert(wire_target("tls://relay.example:9443/", host, sizeof(host), 8443, &port));
    assert(port == 9443 && !strcmp(host, "relay.example"));
    assert(wire_target("https://relay.example", host, sizeof(host), 8443, &port) && port == 8443);
    const char *bad[] = {"", "x:0", "x:65536", "x:999999999999", "http://x", "x/path", "user@x", "x:-1", "x:", "[::1]:8443"};
    for (unsigned i = 0; i < sizeof(bad)/sizeof(*bad); ++i) assert(!wire_target(bad[i], host, sizeof(host), 8443, &port));
}
static void test_login(void) {
    reset(); rx("{\"type\":\"hello\",\"version\":2}"); assert(strstr(test_tx, "\"op\":\"login\""));
    rx("{\"type\":\"device\",\"id\":\"r1\",\"user_code\":\"ABCD\",\"verification_uri\":\"https://id.example/verify\",\"expires_in\":600}");
    assert(g->stage == LOGIN && strstr(g->panel, "ABCD"));
    rx("{\"type\":\"link_required\",\"id\":\"r1\",\"code\":\"0123456789ABCDEF\",\"expires_in\":300}");
    assert(g->stage == LINK);
    rx("{\"type\":\"link_candidate\",\"discord_id\":\"123\",\"name\":\"Alice\"}");
    assert(g->stage == CONFIRM && !g->authed);
    handle_key(sk_Enter); assert(strstr(test_tx, "link_confirm") && strstr(test_tx, "123"));
    rx("{\"type\":\"authenticated\",\"id\":\"r2\",\"token\":\"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFG\",\"discord_id\":\"123\"}");
    assert(g->authed && g->stage == GUILDS && strstr(test_tx, "guilds"));
    assert(token_valid(g->saved.token));
    load(); assert(token_valid(g->saved.token));
}
static void test_resume_fallback_and_profile_binding(void) {
    reset(); copy(g->saved.token, TOKEN_LEN, "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFG");
    rx("{\"type\":\"hello\",\"version\":2}"); assert(strstr(test_tx, "resume"));
    rx("{\"type\":\"error\",\"id\":\"r1\",\"code\":\"invalid_session\"}");
    assert(!g->saved.token[0] && strstr(test_tx, "login"));
    reset(); copy(g->saved.target, sizeof(g->saved.target), "192.0.2.1:9443"); copy(g->saved.username, sizeof(g->saved.username), "Alice");
    copy(g->saved.token, TOKEN_LEN, "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFG");
    test_keys[0] = sk_Enter; test_keys[1] = 100; test_keys[2] = sk_Enter;
    assert(setup()); assert(!g->saved.token[0] && g->port == 9443);
}
static void test_channel_negotiation(void) {
    active(); g->entries[0].send = g->entries[0].history = true;
    copy(g->entries[0].id, ID_LEN, "21"); copy(g->entries[0].name, NAME_LEN, "general");
    g->count = 1; g->picker = true;
    handle_key(sk_Enter); assert(!strcmp(g->channel, "20")); assert(strstr(test_tx, "select_channel"));
    rx("{\"type\":\"selected_channel\",\"id\":\"r1\",\"guild_id\":\"10\",\"channel_id\":\"21\"}");
    assert(!strcmp(g->channel, "21") && !g->picker && strstr(test_tx, "history"));
    rx("{\"type\":\"message\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"100\",\"text\":\"old\"}");
    assert(g->row_count == 0);
    rx("{\"type\":\"reset\",\"reason\":\"access_changed\"}"); assert(!g->channel[0] && g->stage == GUILDS);
    rx("{\"type\":\"selected_channel\",\"id\":\"r1\",\"guild_id\":\"10\",\"channel_id\":\"21\"}"); assert(!g->channel[0]);
}
static void test_history_live_merge_and_delete(void) {
    active(); history();
    rx("{\"type\":\"message\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"101\",\"author\":\"a\",\"text\":\"live\"}");
    rx("{\"type\":\"history_begin\",\"id\":\"r1\",\"channel_id\":\"20\"}");
    rx("{\"type\":\"message\",\"id\":\"r1\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"99\",\"author\":\"b\",\"text\":\"older\"}");
    rx("{\"type\":\"message\",\"id\":\"r1\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"101\",\"author\":\"a\",\"text\":\"live\"}");
    assert(g->row_count == 2 && !strcmp(g->rows[0].id, "99") && !strcmp(g->rows[1].id, "101"));
    rx("{\"type\":\"message_deleted\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"99\"}");
    assert(g->row_count == 1);
    rx("{\"type\":\"message\",\"id\":\"r1\",\"guild_id\":\"10\",\"channel_id\":\"20\",\"message_id\":\"99\",\"text\":\"stale\"}");
    assert(g->row_count == 1);
}
static void test_send_ack_and_fragmented_frames(void) {
    active(); copy(g->input, INPUT_LEN, "hello \"Discord\""); handle_key(sk_Enter);
    assert(g->send_pending && g->row_count == 0 && strstr(test_tx, "\\\"Discord\\\""));
    rx("{\"type\":\"error\",\"id\":\"r1\",\"code\":\"rate_limited\"}");
    assert(!g->send_pending && g->input[0]); handle_key(sk_Enter);
    const char *frame = "{\"type\":\"sent\",\"id\":\"r2\"}\n";
    for (; *frame; ++frame) feed(*frame);
    assert(!g->send_pending && !g->input[0] && !g->rx_len);
    reset(); for (unsigned i = 0; i < FRAME_LEN; ++i) feed('x'); assert(g->done);
}
static void test_pagination_and_stale_replies(void) {
    reset(); g->authed = true; g->stage = GUILDS; list_page(0);
    rx("{\"type\":\"guild\",\"id\":\"r1\",\"guild_id\":\"10\",\"name\":\"Cemetech\"}");
    rx("{\"type\":\"guilds_end\",\"id\":\"r1\",\"next_offset\":24}");
    assert(g->count == 1 && g->next_page == 24 && !g->busy);
    handle_key(sk_Right); assert(g->page_offset == 24 && strstr(test_tx, "\"offset\":24"));
    rx("{\"type\":\"guild\",\"id\":\"r1\",\"guild_id\":\"11\",\"name\":\"stale\"}");
    assert(!g->count);
    rx("{\"type\":\"guild\",\"id\":\"r2\",\"guild_id\":\"12\",\"name\":\"Other\"}");
    rx("{\"type\":\"guilds_end\",\"id\":\"r2\",\"next_offset\":null}");
    handle_key(sk_Enter); assert(!g->guild[0]);
    rx("{\"type\":\"selected_guild\",\"id\":\"r3\",\"guild_id\":\"12\"}");
    assert(!strcmp(g->guild, "12") && g->picker && g->stage == CHAT && strstr(test_tx, "channels"));
}
static void test_bounded_parser_and_transcript(void) {
    uint32_t rng = 1; wire_object obj;
    for (unsigned trial = 0; trial < 10000; ++trial) {
        char input[64]; unsigned len = trial % sizeof(input);
        for (unsigned i = 0; i < len; ++i) { rng = rng * 1664525UL + 1013904223UL; input[i] = (char)(32 + (rng % 96)); }
        input[len] = 0; (void)wire_parse(&obj, input);
    }
    active();
    for (unsigned i = 1; i <= 200; ++i) { char id[21]; snprintf(id, sizeof(id), "%u", i); append("message", id, COL_FG); }
    assert(g->row_count == ROWS && !strcmp(g->rows[ROWS - 1].id, "200"));
    append("old", "1", COL_FG); assert(g->row_count == ROWS && strcmp(g->rows[0].id, "1"));
}
int main(void) {
    palette();
    test_wire(); test_targets(); test_login(); test_resume_fallback_and_profile_binding();
    test_channel_negotiation(); test_history_live_merge_and_delete(); test_send_ack_and_fragmented_frames();
    test_pagination_and_stale_replies(); test_bounded_parser_and_transcript();
    printf("9 client test groups passed; state size %zu bytes (host ABI)\n", sizeof(app_t));
    return 0;
}
