PYTHON ?= python

all::
	true

doc::
	doxygen gmus0-doc.cfg

check::
	:> gmus.log
	$(PYTHON) -m unittest -v -f GMus0TestCase

clean::
	$(RM) $(wildcard *.pyc *.log *~)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)
