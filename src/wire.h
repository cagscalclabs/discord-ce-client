#ifndef DISCORD_WIRE_H
#define DISCORD_WIRE_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define WIRE_FIELDS 24
typedef struct { char *key, *value; char kind; } wire_field;
typedef struct { wire_field fields[WIRE_FIELDS]; unsigned count; } wire_object;
/* Protocol v2 uses flat objects only. Parsing unescapes strings in place. */
bool wire_parse(wire_object *obj, char *line);
const char *wire_string(const wire_object *obj, const char *key);
bool wire_uint(const wire_object *obj, const char *key, uint32_t *value);
bool wire_bool(const wire_object *obj, const char *key);
bool wire_quote(char *out, size_t capacity, const char *input);
bool wire_target(const char *input, char *host, size_t capacity, uint16_t default_port, uint16_t *port);
bool wire_id(const char *id);
#endif
