## weaves

TOP ?= ..

include $(TOP)/ldr/defs.mk

## R modelling

X_R = Rscript

S_DIR ?= /cache/baks/11
S_TBL ?= tbl00
S_FILE ?= localhost:4444

all: all-local1

all-local1: rp0.dat

rp0.dat: rp1.R
	$(X_R) rp1.R $(S_DIR)/ingrss0/tbl00.dat $(S_TBL) $(S_FILE)

clean:
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff) $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

