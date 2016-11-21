## weaves
# Test make file for MInfo.py module testing.

PYTHON ?= python3
UUT ?= MInfoTestCase2
FILE ?= minfo.log
SDIR ?= media
PYTHONIOENCODING=utf-8
PYTHONPATH=..

all::
	true

check::
	:> $(FILE)
	$(PYTHON) -m unittest -v -f $(UUT)

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)

.PHONY: uninstall

uninstall::
	-pip3 uninstall --yes minfo

SFILE ?= dist/minfo-0.1.0.tar.gz

$(SFILE):
	python setup.py sdist

install: uninstall $(SFILE) 
	pip3 install $(SFILE) --user
