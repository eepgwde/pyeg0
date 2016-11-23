## weaves
# Test make file for MInfo.py module testing.

PYTHON ?= python3
UUT ?= MInfoTestCase
FILE ?= minfo.log
SDIR ?= tests/media
PYTHONIOENCODING=utf-8
PYTHONPATH=..

export SDIR

all::
	true

ifneq ($(UUT),)

check::
	:> $(FILE)
	$(PYTHON) -m unittest -v tests.$(UUT)

else

check::
	:> $(FILE)
	$(PYTHON) -m unittest discover -v -s tests

endif 

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)

## Install

SFILE ?= dist/minfo-0.1.0.tar.gz

.PHONY: uninstall dist-local

uninstall::
	rm -f $(wildcard dist/*.tar.gz)
	-$(shell -c "cd $(HOME)/.local; -pip3 uninstall --yes minfo")

dist-local:
	python setup.py sdist

install: uninstall dist-local
	pip3 install $(wildcard dist/*.tar.gz) --user
