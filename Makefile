.PHONY:
all: stow

.PHONY: stow
stow: vendor/stow-2.2.2/dist/bin/stow

vendor/stow-2.2.2/dist/bin/stow: vendor/stow-2.2.2
	cd vendor/stow-2.2.2 && ./configure --prefix=$(CURDIR)/vendor/stow-2.2.2/dist && make && make install

vendor/stow-2.2.2: vendor/stow-2.2.2.tar.gz
	tar xf $< -C $(@D)
