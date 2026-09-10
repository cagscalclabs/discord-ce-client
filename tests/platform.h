/* Host-only platform substitutes. Never included in calculator builds. */
#ifndef DISCORD_TEST_PLATFORM_H
#define DISCORD_TEST_PLATFORM_H
#include <assert.h>
static char test_tx[4096];
static uint8_t test_keys[64]; static unsigned test_key_pos;
static uint32_t test_time;
static unsigned char test_saved[512]; static bool test_saved_exists;
typedef int lwip_error_t;
typedef int lwip_socket_event_type_t;
struct lwip_socket { void *netif; };
typedef struct { int current; } lwip_socket_state_data_t;
enum { LWIP_OK, LWIP_SOCKET_ALTCP_TLS, LWIP_NETIF_EXT, LWIP_SOCKET_EV_ERROR,
       LWIP_SOCKET_EV_STATE_CHANGE, LWIP_STATUS_CONNECTED, LWIP_STATUS_CLOSED,
       LWIP_STATUS_RESET, LWIP_SOCKET_EVENTF_ALL };
#define LWIP_SOCKET_SVC_DHCP 1
#define LWIP_SOCKET_SVC_DNS 2
#define LWIP_SOCKET_SVC_SNTP 4
enum { sk_Mode=1, sk_Graph, sk_Clear, sk_Up, sk_Down, sk_Enter, sk_Window,
       sk_Yequ, sk_Left, sk_Right, sk_Trace, sk_Del, sk_Alpha, sk_GraphVar };
static uint8_t ti_Open(const char *name, const char *mode) { (void)name; return *mode == 'r' ? test_saved_exists : 1; }
static size_t ti_Write(const void *data, size_t size, size_t count, uint8_t h) {
    (void)h; assert(size * count <= sizeof(test_saved)); memcpy(test_saved, data, size * count); test_saved_exists = true; return count;
}
static size_t ti_Read(void *data, size_t size, size_t count, uint8_t h) {
    (void)h; memcpy(data, test_saved, size * count); return count;
}
static void ti_Close(uint8_t h) { (void)h; }
static void ti_SetArchiveStatus(bool b, uint8_t h) { (void)b; (void)h; }
static uint32_t lwip_now_ms(void) { return test_time; }
static lwip_error_t lwip_socket_write(struct lwip_socket *s, const uint8_t *p, size_t n) {
    (void)s; assert(n < sizeof(test_tx)); memcpy(test_tx, p, n); test_tx[n] = 0; return LWIP_OK;
}
static int lwip_socket_create(struct lwip_socket *s, int t, int b, void *a, unsigned long ms) { (void)s;(void)t;(void)b;(void)a;(void)ms; return 0; }
static void lwip_socket_on_event(struct lwip_socket *s, int t, void (*cb)(struct lwip_socket *, int, const void *, void *), void *arg) { (void)s;(void)t;(void)cb;(void)arg; }
static int lwip_netif_request_services(void *n, int f, unsigned long t, void *cb, void *arg) { (void)n;(void)f;(void)t;(void)cb;(void)arg; return 0; }
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
