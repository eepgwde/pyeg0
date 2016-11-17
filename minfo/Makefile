## weaves
# Test make file for MInfo.py module testing.

PYTHON ?= python3
UUT ?= MInfoTestCase2
FILE ?= minfo.log
SDIR ?= media
PYTHONIOENCODING=utf-8

all::
	true

check::
	:> $(FILE).log
	$(PYTHON) -m unittest -v -f $(UUT)

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)
