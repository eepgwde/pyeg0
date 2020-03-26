## weaves

## R modelling

## On my site cache/out up the tree

X_R = R CMD BATCH 

X_MODEL ?= gbm

## rpart trees are the all goal

RTGTS00 ?= $(wildcard smava*.ipynb)
RTGTS01 := $(RTGTS00:.ipynb=.R)
RTGTS02 := $(RTGTS00:.ipynb=.Rout)

all: $(RTGTS02) predictions.rdata

all-local: $(RTGTS01)

clean::
	$(RM) $(wildcard *-*.jpeg) 
	$(RM) $(wildcard *-*.tiff) $(wildcard *-*.log)
	$(RM) $(wildcard *-check.flag) $(wildcard *-*.dat)
	$(RM) $(wildcard smava*.Rout)

## Notebook to script with run

smava%.R: smava%.ipynb
	jupyter nbconvert --stdout --to python $< | sed '1,2d' > $@

smava%.rdata smava%.Rout:: smava%.R
	$(X_R) $<

predictions.rdata: smava01.dat
	cp $< $@

## Snapshotting

dist-local::
	$(MAKE) MAKEFLAGS="$(MAKEFLAGS)" -f dstr.mk dist-local

dist: dist-local 



