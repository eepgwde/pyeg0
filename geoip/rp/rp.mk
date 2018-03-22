## weaves

TOP ?= ..

include $(TOP)/ldr/defs.mk

## R modelling

X_R = Rscript

T_DIR ?= /cache/incoming/kaggle

S_FILE ?= localhost:4444

all: all-local1

all-local1: rp0.dat

rp0.dat: rp1.R
	$(X_R) rp1.R $(S_FILE)

clean:
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff) $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

