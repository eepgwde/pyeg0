## weaves

## R modelling

## On my site cache/out up the tree

X_R = Rscript

X_MODEL ?= gbm

## rpart trees are the all goal

all-local: predictions.rdata


## Not a model

## This puts NZV into the br0 list.
## Run br4.R manually and adjust br4a.R to remove the NZV
predictions.rdat: smava00.R bak/in/train.rdata bak/in/test.rdata
	$(X_R) smava00.R

clean::
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)


## Snapshotting

dist-local::
	$(MAKE) MAKEFLAGS="$(MAKEFLAGS)" -f dstr.mk dist-local

dist: dist-local 



