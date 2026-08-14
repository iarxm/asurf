PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
BASH_COMPLETIONDIR=$(PREFIX)/share/bash-completion/completions
ZSH_COMPLETIONDIR=$(PREFIX)/share/zsh/site-functions

TOOLS=$(wildcard utl/*)
MPX_CFG=$(HOME)/.config/mpv/profile/mpx

all:
	@echo "Run 'make install' to install the scripts."

install-mpx:
	install -d $(MPX_CFG)
	#sudo -u $(USER) cp -r mpx-cfg/* $(MPX_CFG)

install:
	install -d $(BINDIR)
	install -m 755 asurf $(BINDIR)
	install -m 755 $(TOOLS) $(BINDIR)
	install -d $(BASH_COMPLETIONDIR)
	install -m 644 completions/msurf.bash $(BASH_COMPLETIONDIR)/msurf
	install -d $(ZSH_COMPLETIONDIR)
	install -m 644 completions/_msurf $(ZSH_COMPLETIONDIR)/_msurf

uninstall:
	rm -f $(addprefix $(BINDIR)/, $(notdir $(TOOLS)))
	rm $(BINDIR)/asurf
	rm -f $(BASH_COMPLETIONDIR)/msurf
	rm -f $(ZSH_COMPLETIONDIR)/_msurf

uninstall-user:
	$(MAKE) uninstall PREFIX="$(HOME)/.local/usr"

install-user:
	# user level installation for testing 
	$(MAKE) install PREFIX="$(HOME)/.local/usr"
