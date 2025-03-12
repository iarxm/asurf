PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

TOOLS=$(wildcard utl/*)
MPX=$(HOME)/.config/mpx

all:
	@echo "Run 'make install' to install the scripts."

install-mpv:
	install -d $(MPX)
	sudo -u $(USER) cp -r mpx/* $(MPX)

install:
	install -d $(BINDIR)
	install -m 755 asurf $(TOOLS) $(BINDIR)

install-test:
	# user level installation for testing without sudo
	$(MAKE) install PREFIX="$(HOME)/.local/usr"
