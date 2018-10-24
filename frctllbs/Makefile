## weaves
# Test make file for MInfo.py module testing.

PKG := $(notdir $(PWD))

PYTHON ?= python3
PIP ?= pip3
UUT ?= 
X_LOGFILE ?= test.log
SDIR ?= tests/media
PYTHONIOENCODING=utf-8

PROG0 ?= $(HOME)/.local/bin/frctl
PROG0_FLAGS ?= $(HOME)/.local/bin/frctl

export SDIR
export X_LOGFILE

all::
	true

ifneq ($(UUT),)

check:: $(X_LOGFILE)
	:> $(X_LOGFILE)
	$(PYTHON) -m unittest -v tests.$(UUT)
	test -d contrib || mkdir contrib
	cp $(X_LOGFILE) contrib

else

check:: $(X_LOGFILE)
	:> $(X_LOGFILE)
	$(PYTHON) -m unittest discover -v -s tests

endif 

check:: contrib/$(X_LOGFILE)

contrib/$(X_LOGFILE): $(X_LOGFILE)
	cp $< $@
	

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out contrib/*.log)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)

## Install

.PHONY: uninstall dist-local distinstall check-tool

uninstall::
	rm -f $(wildcard dist/*.tar.gz)
	-$(SHELL) -c "cd $(HOME)/.local; $(PIP) uninstall --yes $(PKG)"

dist-local:
	cp $(wildcard tests/test_*.py) contrib
	$(PYTHON) setup.py sdist

distinstall: uninstall dist-local
	$(PIP) install --user $(wildcard dist/*.tar.gz)

install: uninstall 
	$(PIP) install --user -e .

clean::
	-$(SHELL) -c "find . -type d -name __pycache__ -exec rm -rf {} \;"
	-$(SHELL) -c "find . -type f -name '*.log' -delete "
	-$(SHELL) -c "find . -type f -name '*~' -delete "
	-$(SHELL) -c "find . -type d -name '*egg*' -exec rm -rf {} \; "
	rm -f $(wildcard dist/*)
	rm -f ChangeLog AUTHORS

