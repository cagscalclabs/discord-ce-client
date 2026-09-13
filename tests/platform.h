/* Host-only platform substitutes. Never included in calculator builds. */
#ifndef DISCORD_TEST_PLATFORM_H
#define DISCORD_TEST_PLATFORM_H
#include <assert.h>
static char test_tx[4096];
static uint8_t test_keys[64]; static unsigned test_key_pos;
static uint32_t test_time;
/* Two-slot appvar store for tests: slot 0 = DISCRD, slot 1 = DISCTK. */
typedef struct { const char *name; unsigned char data[2048]; size_t size; bool exists; size_t pos; } test_appvar_t;
static test_appvar_t test_appvars[2] = { {"DISCRD", {0}, 0, false, 0}, {"DISCTK", {0}, 0, false, 0} };
typedef int lwip_error_t;
typedef int lwip_socket_event_type_t;
struct netif { int unused; };
typedef struct { uint8_t service_id, status, ready_bitmap; } lwip_netif_service_event_t;
enum { LWIP_NETIF_SERVICE_UP, LWIP_NETIF_SERVICE_FAILED, LWIP_NETIF_SERVICE_TIMEOUT };
struct lwip_socket { void *netif; };
typedef struct { int current; } lwip_socket_state_data_t;
typedef struct { uint16_t component, operation; int raw_error; lwip_error_t err; int status; } lwip_socket_error_data_t;
enum { LWIP_EV_INFO, LWIP_EV_ERROR, LWIP_DBG_MOD_TLS };
struct lwip_event {
    uint8_t module, kind;
    union { const char *msg; struct { uint32_t loc; uint16_t extra; } code; } data;
};
#define LWIP_EVENT_CODE_FILE(code) ((uint8_t)((code) >> 24))
#define LWIP_EVENT_CODE_LINE(code) ((uint32_t)(code) & 0x00FFFFFFu)
static const char *lwip_debug_file_name(uint8_t id) { (void)id; return "handshake.c"; }
static void lwip_set_event_cb(void (*cb)(const struct lwip_event *)) { (void)cb; }
struct lwip_traceback_entry {
    uint8_t module, kind, file; uint32_t line; uint16_t extra, component, operation;
    int raw_error; uint16_t mapped_error, status;
};
static const struct lwip_traceback_entry *lwip_get_traceback(uint8_t *count) { *count = 0; return NULL; }
enum { LWIP_OK, LWIP_SOCKET_ALTCP_TLS, LWIP_NETIF_EXT, LWIP_SOCKET_EV_ERROR,
       LWIP_SOCKET_EV_STATE_CHANGE, LWIP_STATUS_CONNECTED, LWIP_STATUS_CLOSED,
       LWIP_STATUS_RESET, LWIP_SOCKET_EVENTF_ALL };
#define LWIP_SOCKET_SVC_DHCP 1
#define LWIP_SOCKET_SVC_DNS 2
#define LWIP_SOCKET_SVC_SNTP 4
enum { sk_Mode=1, sk_Graph, sk_Clear, sk_Up, sk_Down, sk_Enter, sk_Window,
       sk_Yequ, sk_Left, sk_Right, sk_Trace, sk_Del, sk_Alpha, sk_GraphVar };
#ifndef SEEK_SET
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif
static uint8_t ti_Open(const char *name, const char *mode) {
    for (uint8_t i = 0; i < 2; ++i) {
        if (strcmp(test_appvars[i].name, name)) continue;
        if (mode[0] == 'w') { test_appvars[i].size = 0; test_appvars[i].exists = true; }
        else if (!test_appvars[i].exists) return 0; /* "r" or "r+" on missing file */
        test_appvars[i].pos = 0;
        return i + 1;
    }
    return 0;
}
static size_t ti_Write(const void *data, size_t size, size_t count, uint8_t h) {
    if (!h || h > 2) return 0;
    test_appvar_t *av = &test_appvars[h - 1];
    size_t n = size * count;
    assert(av->pos + n <= sizeof(av->data));
    memcpy(av->data + av->pos, data, n);
    av->pos += n;
    if (av->pos > av->size) av->size = av->pos;
    return count;
}
static size_t ti_Read(void *data, size_t size, size_t count, uint8_t h) {
    if (!h || h > 2) return 0;
    test_appvar_t *av = &test_appvars[h - 1];
    size_t n = size * count;
    if (av->pos + n > av->size) return 0;
    memcpy(data, av->data + av->pos, n);
    av->pos += n;
    return count;
}
static void ti_Rewind(uint8_t h) { if (h && h <= 2) test_appvars[h - 1].pos = 0; }
static int ti_Seek(int offset, unsigned int origin, uint8_t h) {
    if (!h || h > 2) return -1;
    test_appvar_t *av = &test_appvars[h - 1];
    size_t base = origin == SEEK_SET ? 0 : origin == SEEK_END ? av->size : av->pos;
    av->pos = (size_t)((int)base + offset);
    return 0;
}
static uint16_t ti_Tell(uint8_t h) { return (h && h <= 2) ? (uint16_t)test_appvars[h - 1].pos : 0; }
static void ti_Close(uint8_t h) { (void)h; }
static void ti_SetArchiveStatus(bool b, uint8_t h) { (void)b; (void)h; }
static uint32_t lwip_now_ms(void) { return test_time; }
static lwip_error_t lwip_socket_write(struct lwip_socket *s, const uint8_t *p, size_t n) {
    (void)s; assert(n < sizeof(test_tx)); memcpy(test_tx, p, n); test_tx[n] = 0; return LWIP_OK;
}
static int lwip_socket_create(struct lwip_socket *s, int t, int b, void *a, unsigned long ms) { (void)s;(void)t;(void)b;(void)a;(void)ms; return 0; }
static void lwip_socket_on_event(struct lwip_socket *s, int t, void (*cb)(struct lwip_socket *, int, const void *, void *), void *arg) { (void)s;(void)t;(void)cb;(void)arg; }
static lwip_error_t test_service_error;
static int test_service_flags;
static bool test_services_ready = true;
static int lwip_netif_request_services(void *n, int f, unsigned long t, void *cb, void *arg) {
    (void)n;(void)t;(void)cb;(void)arg; test_service_flags = f; return test_service_error;
}
static bool lwip_are_services_ready(void *n, int f) { (void)n; (void)f; return test_services_ready; }
static int lwip_socket_connect(struct lwip_socket *s, const char *h, uint16_t p) { (void)s;(void)h;(void)p; return 0; }
static void lwip_socket_destroy(struct lwip_socket *s) { (void)s; }
static size_t lwip_socket_available(struct lwip_socket *s) { (void)s; return 0; }
static size_t lwip_socket_read(struct lwip_socket *s, uint8_t *p, size_t n) { (void)s;(void)p;(void)n; return 0; }
static void lwip_service_events(void) {}
static uint8_t os_GetCSC(void) { assert(test_key_pos < sizeof(test_keys)); return test_keys[test_key_pos++]; }
static char key_to_char(uint8_t key, uint8_t mode) { (void)mode; return key == 100 ? '9' : 0; }
static bool lwip_example_stack_start(void) { return true; }
static void lwip_example_gfx_stop(void) {}
static int lwip_example_finish(int status) { return status; }
static void lwip_example_show_and_wait(const char *a, const char *b) { (void)a;(void)b; }
static void *mem_request(size_t n) { return malloc(n); }
static void mem_release(void *p) { free(p); }
static void *mem_malloc(size_t n) { return malloc(n); }
static void mem_free(void *p) { free(p); }
#define gfx_RGBTo1555(r,g,b) 0
static void gfx_SetTextFGColor(uint8_t c) { (void)c; }
static void gfx_SetTextBGColor(uint8_t c) { (void)c; }
static void gfx_PrintStringXY(const char *t, int x, int y) { (void)t;(void)x;(void)y; }
static void gfx_SetColor(uint8_t c) { (void)c; }
static void gfx_FillRectangle(int x, int y, int w, int h) { (void)x;(void)y;(void)w;(void)h; }
static void gfx_FillScreen(uint8_t c) { (void)c; }
static void gfx_BlitBuffer(void) {}
static void gfx_SetPalette(const uint16_t *p, size_t n, unsigned off) { (void)p; assert(n == 12 && off == 16); }
static void gfx_SetMonospaceFont(unsigned n) { (void)n; }
static void gfx_SetTextScale(int x, int y) { (void)x;(void)y; }
#endif
