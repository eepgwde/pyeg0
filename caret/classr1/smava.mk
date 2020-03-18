## weaves

## R modelling

## On my site cache/out up the tree

X_R = R CMD BATCH 

X_MODEL ?= gbm

## rpart trees are the all goal

RTGTS00 ?= $(wildcard smava*.ipynb)
RTGTS01 := $(RTGTS00:.ipynb=.Rout)

all-local: predictions.rdata $(RTGTS01)


predictions.rdat: smava00.R bak/in/train.rdata bak/in/test.rdata
	$(X_R) smava00.R

clean::
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

## Notebook to script with run

smava%.R: smava%.ipynb
	jupyter nbconvert --stdout --to python $< > $@

smava%.Rout: smava%.R
	$(X_R) $<


## Snapshotting

dist-local::
	$(MAKE) MAKEFLAGS="$(MAKEFLAGS)" -f dstr.mk dist-local

dist: dist-local 



