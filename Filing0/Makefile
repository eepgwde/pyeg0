PYTHON ?= python
ROOT0 ?= Filing0


IALL0 = $(wildcard *_input.csv)
export ARGS ?= $(firstword $(IALL0))

OALL0 = $(IALL0:_input.csv=_exclude.csv)
DALL0 = $(OALL0:.csv=.diff0)
DALL1 = $(OALL0:.csv=.diff1)

OALM0 = $(IALL0:_input.csv=_include.csv)
DALM0 = $(OALM0:.csv=.diff0)
DALM1 = $(OALM0:.csv=.diff1)

%_exclude.diff0: %_input.csv %_exclude.csv
	-diff -y $+ > $@

%_exclude.diff1: %_exclude.csv t/%_output.csv 
	-diff -y $+ > $@

%_include.diff0: %_input.csv %_include.csv
	-diff -y $+ > $@

%_include.diff1: %_include.csv t/%_output.csv 
	-diff -y $+ > $@

all::
	@echo $(ARGS)
	@echo $(IALL0)
	@echo $(OALL0)
	@echo $(DALL0)

doc::
	doxygen $(ROOT0)-doc.cfg

check::
	:> $(ROOT0).log
	$(PYTHON) -m unittest -v -f $(ROOT0)TestCase

check-all:: $(DALL0) $(DALL1) $(DALM0) $(DALM1)

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)
	$(RM) $(wildcard *.json *.diff* *_*clude.csv)

distclean::
	$(RM) -rf html 
	$(RM) $(wildcard *.json)
