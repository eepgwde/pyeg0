## weaves

TOP ?= ..

include $(TOP)/ldr/defs.mk

## R modelling

X_R = Rscript

S_DIR ?= /cache/baks/11/ingrss0
S_TBL ?= noclicks
S_CLS ?= classes
S_FILE ?= localhost:4444

all: all-local1

all-local1: thw0.dat thw1.dat

thw0.dat: def0.R
	$(X_R) def0.R $(S_FILE)

thw1.dat: rp1.R thw0.dat
	$(X_R) rp1.R thw0.dat $(S_TBL) $(S_CLS)

clean:
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff) $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

