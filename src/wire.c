#include "wire.h"
#include <string.h>

static void whitespace(char **p) { while (**p == ' ' || **p == '\r' || **p == '\t') ++*p; }
static int hex(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}
static bool unicode4(char **p, uint32_t *value) {
    *value = 0;
    for (unsigned i = 0; i < 4; ++i) {
        int h = hex(**p); if (h < 0) return false;
        *value = (*value << 4) | (unsigned)h; ++*p;
    }
    return true;
}
static bool string(char **cursor, char **result) {
    char *p = *cursor, *out;
    if (*p++ != '"') return false;
    *result = out = p;
    while (*p && *p != '"') {
        unsigned char c = (unsigned char)*p++;
        if (c < 32) return false;
        if (c != '\\') { *out++ = c; continue; }
        c = (unsigned char)*p++;
        if (!c) return false;
        if (c == 'u') {
            uint32_t cp, low;
            if (!unicode4(&p, &cp) || cp == 0) return false;
            if (cp >= 0xD800 && cp <= 0xDBFF) {
                if (*p++ != '\\' || *p++ != 'u' || !unicode4(&p, &low) || low < 0xDC00 || low > 0xDFFF) return false;
                cp = 0x10000UL + ((cp - 0xD800) << 10) + low - 0xDC00;
            } else if (cp >= 0xDC00 && cp <= 0xDFFF) return false;
            if (cp < 0x80) *out++ = (char)cp;
            else {
                if (cp >= 0x10000UL) { *out++ = 0xF0 | (cp >> 18); *out++ = 0x80 | ((cp >> 12) & 63); }
                else if (cp >= 0x800) *out++ = 0xE0 | (cp >> 12);
                else { *out++ = 0xC0 | (cp >> 6); *out++ = 0x80 | (cp & 63); continue; }
                *out++ = 0x80 | ((cp >> 6) & 63); *out++ = 0x80 | (cp & 63);
            }
        } else {
            switch (c) {
            case '"': case '\\': case '/': *out++ = c; break;
            case 'n': *out++ = '\n'; break;
            case 'r': *out++ = '\r'; break;
            case 't': *out++ = '\t'; break;
            case 'b': *out++ = '\b'; break;
            case 'f': *out++ = '\f'; break;
            default: return false;
            }
        }
    }
    if (*p != '"') return false;
    *cursor = p + 1; *out = 0; return true;
}
bool wire_parse(wire_object *obj, char *line) {
    char *p = line; obj->count = 0; whitespace(&p);
    if (*p++ != '{') return false;
    whitespace(&p);
    if (*p == '}') { ++p; whitespace(&p); return !*p; }
    for (;;) {
        char delimiter;
        if (obj->count == WIRE_FIELDS) return false;
        wire_field *f = &obj->fields[obj->count];
        if (!string(&p, &f->key)) return false;
        for (unsigned i = 0; i < obj->count; ++i) if (!strcmp(obj->fields[i].key, f->key)) return false;
        whitespace(&p); if (*p++ != ':') return false; whitespace(&p);
        if (*p == '"') {
            f->kind = 's'; if (!string(&p, &f->value)) return false;
            whitespace(&p); delimiter = *p;
        } else {
            char *end; f->value = p;
            if (*p >= '0' && *p <= '9') {
                f->kind = 'n'; if (*p == '0' && p[1] >= '0' && p[1] <= '9') return false;
                while (*p >= '0' && *p <= '9') ++p;
            } else if (!strncmp(p, "true", 4)) { f->kind = 'b'; p += 4; }
            else if (!strncmp(p, "false", 5)) { f->kind = 'b'; p += 5; }
            else if (!strncmp(p, "null", 4)) { f->kind = '0'; p += 4; }
            else return false;
            end = p; whitespace(&p); delimiter = *p; *end = 0;
        }
        ++obj->count;
        if (delimiter != ',' && delimiter != '}') return false;
        ++p; whitespace(&p);
        if (delimiter == '}') return !*p;
    }
}
static const wire_field *field(const wire_object *obj, const char *key) {
    for (unsigned i = 0; i < obj->count; ++i) if (!strcmp(obj->fields[i].key, key)) return &obj->fields[i];
    return NULL;
}
const char *wire_string(const wire_object *obj, const char *key) {
    const wire_field *f = field(obj, key); return f && f->kind == 's' ? f->value : "";
}
bool wire_uint(const wire_object *obj, const char *key, uint32_t *value) {
    const wire_field *f = field(obj, key); uint32_t n = 0;
    if (!f || f->kind != 'n') return false;
    for (const char *p = f->value; *p; ++p) {
        unsigned digit = (unsigned)(*p - '0');
        if (n > (UINT32_MAX - digit) / 10) return false;
        n = n * 10 + digit;
    }
    *value = n; return true;
}
bool wire_bool(const wire_object *obj, const char *key) {
    const wire_field *f = field(obj, key); return f && f->kind == 'b' && !strcmp(f->value, "true");
}
bool wire_quote(char *out, size_t capacity, const char *input) {
    size_t n = 0; if (capacity < 3) return false; out[n++] = '"';
    for (; *input; ++input) {
        unsigned char c = (unsigned char)*input;
        if (c < 32 || c > 126) return false;
        if (n + 4 > capacity) return false;
        if (c == '"' || c == '\\') out[n++] = '\\';
        out[n++] = c;
    }
    out[n++] = '"'; out[n] = 0; return true;
}
bool wire_id(const char *id) {
    size_t len = strlen(id);
    if (!len || len > 20 || id[0] == '0') return false;
    for (size_t i = 0; i < len; ++i) if (id[i] < '0' || id[i] > '9') return false;
    return len < 20 || strcmp(id, "18446744073709551615") <= 0;
}
bool wire_target(const char *input, char *host, size_t capacity, uint16_t default_port, uint16_t *port) {
    const char *p = input, *start; size_t len; uint32_t number = 0;
    if (!strncmp(p, "tls://", 6)) p += 6;
    else if (!strncmp(p, "https://", 8)) p += 8;
    start = p;
    while ((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z') ||
           (*p >= '0' && *p <= '9') || *p == '.' || *p == '-') ++p;
    len = (size_t)(p - start);
    if (!len || len >= capacity || !default_port) return false;
    *port = default_port;
    if (*p == ':') {
        ++p; if (*p < '0' || *p > '9') return false;
        while (*p >= '0' && *p <= '9') { number = number * 10 + (unsigned)(*p++ - '0'); if (number > 65535) return false; }
        if (!number) return false; *port = (uint16_t)number;
    }
    if (*p == '/') ++p;
    if (*p) return false;
    memcpy(host, start, len); host[len] = 0; return true;
}
