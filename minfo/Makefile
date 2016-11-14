PYTHON ?= python3
FILE ?= minfo

all::
	true

check::
	:> $(FILE).log
	$(PYTHON) -m unittest -v -f MInfoTestCase

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)
