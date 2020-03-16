## weaves
##
## Snapshots and posting results
##
## sub-make our defs.mk is passed via MAKEFILES

xPWD := $(shell pwd)

X_STAMP ?= $(shell date +%Y%m%dT%H%M)

TARGET ?= walterEAVES

ifeq ($(MAKECMDGOALS),dist-local)

dist-local:: $(TARGET)-$(X_STAMP).zip

$(TARGET)-$(X_STAMP).zip: predictions.rdata smava00.ipynb
	zip $@  $(wildcard smava*-*.jpeg) $+

endif

