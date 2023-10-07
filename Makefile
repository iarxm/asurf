PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
TOOLS=$(wildcard utl/*)
MPX=$(HOME)/.config/mpx

all:
	@echo "Run 'make install' to install the scripts."

install:
	install -d $(BINDIR)
	install -d $(MPX)
	sudo -u $(USER) cp -r mpx/* $(MPX)
	install -m 755 asurf $(TOOLS) $(BINDIR)

