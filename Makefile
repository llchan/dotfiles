STOW_VERSION := 2.2.2
STOW_TAR_GZ := $(CURDIR)/vendor/stow-$(STOW_VERSION).tar.gz
STOW_SRC := $(CURDIR)/vendor/stow-$(STOW_VERSION)
STOW_PREFIX := $(STOW_SRC)/dist
STOW_BIN := $(STOW_PREFIX)/bin/stow

.PHONY:
all: stow

.PHONY: stow
stow: $(STOW_BIN)

$(STOW_BIN): $(STOW_SRC)
	cd $(STOW_SRC) && \
		./configure --prefix=$(STOW_PREFIX) && \
		make && \
		make install

$(STOW_SRC): $(STOW_TAR_GZ)
	mkdir -p $@
	tar xf $< -C $@ --strip-components=1
