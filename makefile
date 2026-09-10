NAME        = DISC
DESCRIPTION = "lwIP Discord Relay"
COMPRESSED  = NO
ARCHIVED    = YES
# lwIP-CE owns the first 8 KiB of the default BSS window.
BSSHEAP_LOW = 0xD072C6

# Default relay host shown in the setup screen (user can change it at runtime)
RELAY_DEFAULT_HOST ?=
RELAY_DEFAULT_PORT ?= 8443
LWIP_CE ?= ../lwip-ce

CFLAGS = -Wall -Wextra -Oz \
    -DRELAY_DEFAULT_HOST=\"$(RELAY_DEFAULT_HOST)\" \
    -DRELAY_DEFAULT_PORT=$(RELAY_DEFAULT_PORT) \
    -I$(LWIP_CE)/examples/common
CXXFLAGS = $(CFLAGS)
LTOFLAGS = -Wall -Wextra -Oz

include $(shell cedev-config --makefile)
