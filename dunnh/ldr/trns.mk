## weaves

TOP ?= ..

include defs.mk

## Make the target directory - needed early on for paths

all: all-local

all-local:
	$(H_) -s $(TOP) relink fls.lst fls1.lst

clean::
	$(SHELL) -c "rm -rf $(X_BASE)/in/*"
