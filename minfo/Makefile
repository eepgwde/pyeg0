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

.PHONY: uninstall

uninstall::
	rm -f $(SFILE)
	-$(shell -c "cd $(HOME)/.local; -pip3 uninstall --yes minfo")

$(SFILE):
	python setup.py sdist

install: uninstall $(SFILE) 
	pip3 install $(SFILE) --user
