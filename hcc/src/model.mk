## weaves

## R modelling

X_R = Rscript

T_DIR ?= /cache/incoming/hcc

H_ = $(notdir $(PWD))_

X_STAMP ?= $(shell date +%Y-%m-%d-%H%M)

all: all-local-hcc5

all-local11: hcc3.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc3-$(X_STAMP).zip

all-local12: hcc4.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc4-$(X_STAMP).zip

all-local13: hcc5.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc5-$(X_STAMP).zip

all-local-hcc5: all-local11 all-local12 all-local13


hcc3-$(X_STAMP).zip: $(wildcard hcc3-*.jpeg)
	zip $@ hcc3.dat pdf2r.csv $+ Rplots.pdf 

hcc3.Rout: hcc3.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc3-0??.jpeg
	Rscript hcc3.R
	mv all.Rout $@
	unix2dos $@

hcc4-$(X_STAMP).zip: $(wildcard hcc4-*.jpeg)
	zip $@ hcc4.dat pdf2-hcc4.csv $+ Rplots.pdf 

hcc4.Rout: hcc4.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc4-0??.jpeg
	Rscript hcc4.R
	mv all.Rout $@
	unix2dos $@

hcc5-$(X_STAMP).zip: $(wildcard hcc5-*.jpeg)
	zip $@ hcc5.dat pdf2-hcc5.csv $+ Rplots.pdf 

hcc5.Rout: hcc5.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc5-0??.jpeg
	Rscript hcc5.R
	mv all.Rout $@
	unix2dos $@


