PYTHON ?= python3
TEST0 ?= GMus0TestCase

all::
	true

doc::
	doxygen gmus0-doc.cfg

check::
	:> gmus.log
	$(PYTHON) -m unittest -v -f $(TEST0)

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)
