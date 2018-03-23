## weaves

TOP ?= ..

include $(TOP)/ldr/defs.mk

## R modelling

X_R = Rscript

S_DIR ?= /cache/baks/11/ingrss0
S_TBL ?= tbl00
S_FILE ?= localhost:4444

all: all-local1

all-local1: rp0.dat

$(S_DIR)/frd0.dat: fraud0.R
	$(X_R) fraud0.R $(S_DIR)/tbl00.dat $(S_TBL) $(S_FILE)

rp0.dat: rp0.R $(S_DIR)/frd0.dat
	$(X_R) rp0.R $(S_DIR)/frd0.dat smpls $(S_FILE)

clean:
	rm -f $(wildcard *-*.jpeg) $(wildcard *-*.tiff) $(wildcard *-*.log) $(wildcard *-check.flag) $(wildcard *-*.dat)

