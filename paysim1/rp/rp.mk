## weaves

## R modelling

X_R = Rscript

T_DIR ?= /cache/incoming/hcc

S_FILE ?= out/xsamples1.csv

## TARGET allows you to specify the data set.
## CLS0 allows you to use a different class of assets.

TARGET ?= xroadsc
CLS0 ?= cwy0

H_ = $(notdir $(PWD))_

X_STAMP ?= $(shell date +%Y-%m-%d-%H%M)

all: $(TARGET)-$(CLS0).zip

all-local1: hcc00.dat

all-local00: ppl00.dat

all-local0: ppl0.dat

all-local3: $(TARGET)-3.dat

all-local4: $(TARGET)-4.dat

all-local5: $(TARGET)-5.dat

all-local7: $(TARGET)-7.dat

all-local8: $(TARGET)-8.dat

all-local9: all-local7 $(TARGET)-9.dat

all-local11: hcc3.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc3-$(X_STAMP).zip

all-local12: hcc4.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc4-$(X_STAMP).zip

all-local13: hcc5.Rout
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_STAMP=$(X_STAMP) hcc5-$(X_STAMP).zip

all-local-hcc5: all-local11 all-local12 all-local13

all-local: all-local8 all-local9


X_TREE0 ?= xroadsc-7.dat
X_TREE1 ?= $(basename $(X_TREE0))r.dat

view0:
	echo $(X_TREE1) $(X_TREE0)



## Complicated one
## make -f model.mk TARGET=uni0 CLS0=modelq1 X_TREE0=xroadsc-8.dat all-local10

all-local10: $(X_TREE1)
	$(MAKE) MAKEFILES=$(lastword $(MAKEFILE_LIST)) MAKEFLAGS=$(MAKEFLAGS) X_TREE=$(X_TREE1) $(TARGET)-$(CLS0).dat
	zip $(basename $(X_TREE0)) $(wildcard $(basename $(X_TREE0))-pp-*.csv) $(wildcard $(TARGET)-$(CLS0)-*.tiff) $(TARGET)-$(CLS0).dat

## Regression work

view2:
	echo $(X_STAMP)


hcc3-$(X_STAMP).zip: $(wildcard hcc3-*.jpeg) hcc3.Rout
	zip $@ hcc3.dat pdf2r.csv $+ Rplots.pdf 

hcc3.Rout: hcc3.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc3-0??.jpeg
	Rscript hcc3.R
	mv all.Rout $@
	unix2dos $@

hcc4-$(X_STAMP).zip: $(wildcard hcc4-*.jpeg) hcc4.Rout
	zip $@ hcc4.dat pdf2-hcc4.csv $+ Rplots.pdf 

hcc4.Rout: hcc4.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc4-0??.jpeg
	Rscript hcc4.R
	mv all.Rout $@
	unix2dos $@

hcc5-$(X_STAMP).zip: $(wildcard hcc5-*.jpeg) hcc5.Rout
	zip $@ hcc5.dat pdf2-hcc5.csv $+ Rplots.pdf 

hcc5.Rout: hcc5.R brA0.R hcc0a.R pdf2.csv out/xncas1.csv
	:> all.Rout
	rm -f hcc5-0??.jpeg
	Rscript hcc5.R
	mv all.Rout $@
	unix2dos $@


## Rules

ppl00.dat: br00.R $(S_FILE)
	$(X_R) $+

ppl0.dat: br0.R ppl00.dat
	$(X_R) br0.R

X_TREE ?= ppl0.dat

## Not a model - partition trees
$(TARGET)-$(CLS0).dat: br1.R $(X_TREE)
	$(X_R) br1.R $(X_TREE) $(TARGET) $(CLS0)
	mv ppl1.dat $(TARGET)-$(CLS0).dat

$(TARGET)-$(CLS0).zip: $(TARGET)-$(CLS0).dat
	for i in $(wildcard $(TARGET)-$(CLS0)-*.txt); do unix2dos $$i; done
	rm -f $@
	zip $@  $(wildcard $(TARGET)-$(CLS0)-*.tiff) $(wildcard $(TARGET)-$(CLS0)-*.txt) 

## Not a model
# This produces the Enquiries Repudiations cross-correlations.
hcc00.dat: hcc1.R out/xncas1.csv
	rm -f $(wildcard ncas1-*.jpeg)
	$(X_R) $+

## This writes NZV to the br0 list.
## Run br4.R manually and adjust br4a.R to remove the NZV
$(TARGET)-3.dat: br3.R br3a.R brA0.R ppl0.dat
	$(X_R) br3.R $(TARGET)
	mv ppl3.dat $@

## This removes NZV and finds correlations
## br4a.r is the set of NZV to remove
$(TARGET)-4.dat: br4.R br4a.R br4a0.R brA0.R $(TARGET)-3.dat
	$(X_R) br4.R $(TARGET)-3.dat
	mv ppl4.dat $@

## This removes correlations and creates another correlation plot
## br5a.r is the set of correlations to remove
$(TARGET)-5.dat: br5.R br5a.R brA0.R $(TARGET)-4.dat
	$(X_R) br5.R $(TARGET)-4.dat
	mv ppl5.dat $@

$(TARGET)-7.dat: br7.R $(TARGET)-5.dat
	$(X_R) $+
	mv ppl7.dat $@

$(TARGET)-8.dat: br8.R $(TARGET)-5.dat
	$(X_R) $+
	mv ppl8.dat $@

$(TARGET)-9.dat: br9.R $(TARGET)-7.dat
	$(X_R) $+
	mv ppl9.dat $@

$(X_TREE1): hcc2.R $(X_TREE0)
	$(X_R) $+
	mv hcc2.dat $@

check: $(TARGET)-check.flag


clean:
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

$(TARGET)-check.flag:: br1.R ppl0.dat
	$(H_) -f $(TARGET) rpart all0
	touch $@

$(TARGET)-check.flag:: br1.R ppl0.dat
	$(H_) -f $(TARGET) rpart all
	touch $@

dist: dist-local remote0

dist-local: check $(T_DIR)/rpart.zip

dist-local1: all-local1
	rm -f ncas1.zip
	zip ncas1 $(wildcard ncas1-*.jpeg)

dist1:
	ssh n1 m_ sftp put $(PWD)/ncas1.zip

$(T_DIR)/rpart.zip: $(wildcard *-*3.tiff) $(wildcard *-*.log)
	rm -f $@
	zip $(T_DIR)/rpart.zip $+


remote0:: $(T_DIR)/rpart.zip
	ssh n1 m_ -d /herts/incoming sftp put $+


## Test: checking 

cargs: cargs.R ppl0.dat
	$(X_R) cargs.R xroadsc

