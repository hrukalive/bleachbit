.PHONY: clean install tests build

prefix ?= /usr/local
bindir ?= $(prefix)/bin
datadir ?= $(prefix)/share

INSTALL = install
INSTALL_DATA = $(INSTALL) -m 644


build:
	echo Nothing to build

clean:
	@rm -vf {.,bleachbit}/*{pyc,pyo}
	@rm -vf dist/bleachbit-*.tar.bz2
	@rm -vf MANIFEST
	make -C po clean
	@rm -vrf locale

install:
	# "binary"
	mkdir -p $(DESTDIR)$(bindir)
	ln -f -s ../..$(datadir)/bleachbit/GUI.py $(DESTDIR)$(bindir)/bleachbit

	# .desktop
	mkdir -p $(DESTDIR)$(datadir)/applications
	$(INSTALL_DATA) bleachbit.desktop $(DESTDIR)$(datadir)/applications/

	# Python code
	mkdir -p $(DESTDIR)$(datadir)/bleachbit
	$(INSTALL_DATA) bleachbit/*.py $(DESTDIR)$(datadir)/bleachbit
	chmod 0755 $(DESTDIR)$(datadir)/bleachbit/GUI.py
	cd $(DESTDIR)$(datadir)/bleachbit && \
	python -O -c "import compileall; compileall.compile_dir('.')" && \
	python -c "import compileall; compileall.compile_dir('.')"


	# icon
	mkdir -p $(DESTDIR)$(datadir)/pixmaps
	$(INSTALL_DATA) bleachbit.png $(DESTDIR)$(datadir)/pixmaps/

	# translations
	make -C po install DESTDIR=$(DESTDIR)

tests:
	cd bleachbit && grep -l unittest *py | xargs -L 1 python


