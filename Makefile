PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

TOOLS=$(wildcard utl/*)
MPX_CFG=$(HOME)/.config/mpx

all:
	@echo "Run 'make install' to install the scripts."

install-mpv:
	install -d $(MPX_CFG)
	#sudo -u $(USER) cp -r mpx-cfg/* $(MPX_CFG)

install:
	install -d $(BINDIR)
	install -m 755 asurf $(BINDIR)
	install -m 755 $(TOOLS) $(BINDIR)

uninstall:
	rm -f $(addprefix $(BINDIR)/, $(notdir $(TOOLS)))
	rm $(BINDIR)/asurf

uninstall-user:
	$(MAKE) uninstall PREFIX="$(HOME)/.local/usr"

install-user:
	# user level installation for testing without sudo - call install from nvim with ease
	$(MAKE) install PREFIX="$(HOME)/.local/usr"
