## weaves

## R modelling

## On my site cache/out up the tree

X_R = R CMD BATCH 

X_MODEL ?= gbm

## rpart trees are the all goal

RTGTS00 ?= $(wildcard smava*.ipynb)
RTGTS01 := $(RTGTS00:.ipynb=.R)
RTGTS02 := $(RTGTS00:.ipynb=.Rout)

all: $(RTGTS02)

all-local: predictions.rdata $(RTGTS01)


predictions.rdat: smava00.R bak/in/train.rdata bak/in/test.rdata
	$(X_R) smava00.R

clean::
	$(RM) $(wildcard *-*.jpeg) 
	$(RM) $(wildcard *-*.tiff) $(wildcard *-*.log)
	$(RM) $(wildcard *-check.flag) $(wildcard *-*.dat)
	$(RM) $(wildcard smava*.Rout)

## Notebook to script with run

smava%.R: smava%.ipynb
	jupyter nbconvert --stdout --to python $< | sed '1,2d' > $@

smava%.Rout: smava%.R
	$(X_R) $<


## Snapshotting

dist-local::
	$(MAKE) MAKEFLAGS="$(MAKEFLAGS)" -f dstr.mk dist-local

dist: dist-local 



