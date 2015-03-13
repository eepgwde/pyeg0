PYTHON ?= python
ROOT0 ?= Filing0

export ARGS ?= $(firstword $(wildcard *_input.csv))

all::
	@echo $(ARGS)

doc::
	doxygen $(ROOT0)-doc.cfg

check::
	:> $(ROOT0).log
	$(PYTHON) -m unittest -v -f $(ROOT0)TestCase

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)
