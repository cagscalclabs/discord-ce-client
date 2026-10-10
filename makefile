NAME        = DISC
DESCRIPTION = "lwIP Discord Relay"
COMPRESSED  = NO
ARCHIVED    = YES
# lwIP-CE owns the first 8 KiB of the default BSS window.
BSSHEAP_LOW = 0xD072C6

# Default relay host shown in the setup screen (user can change it at runtime)
RELAY_DEFAULT_HOST ?= disrelay.cagscalclabs.net
RELAY_DEFAULT_PORT ?= 9443

CFLAGS = -Wall -Wextra -Oz \
    -DRELAY_DEFAULT_HOST=\"$(RELAY_DEFAULT_HOST)\" \
    -DRELAY_DEFAULT_PORT=$(RELAY_DEFAULT_PORT)
CXXFLAGS = $(CFLAGS)
LTOFLAGS = -Wall -Wextra -Oz

include $(shell cedev-config --makefile)
