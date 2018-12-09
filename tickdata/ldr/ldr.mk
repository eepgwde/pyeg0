## weaves

TOP = ..

include defs.mk

## all-local:: $(X_DEST) $(X_TARGETS)

ifeq ($(X_TYPE),)

all: view0 $(X_DEST) all-local

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi

# Invoke again with type and date file.

define GOAL_template =

all-$(1):
	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) MAKEFILES="$(MAKEFILE_LIST)" X_TYPE=$(1) X_DTS=$(2) load0

all-local:: all-$(1)

clean::
	$(shell find $(X_DEST) -type d -name $(1) -print | xargs rm -rf )
	rm -f $(wildcard $(X_BASE)/in/$(1)_*.flg0)

endef

X_SRCS = $(wildcard $(X_BASE)/in/*.csv2)

$(foreach file0,$(X_SRCS), \
	$(eval $(call GOAL_template,$(basename $(notdir $(file0))),$(file0))))

# $(X_BASE)/in/%.csv3: $(X_BASE)/in/%.csv2
#	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) MAKEFILES="$(MAKEFILE_LIST)" $@

else

## Invoked to load each file
## X_TYPE is type of file estrades or esquote
## X_DTS is the file containing the date for each file

# A function to extract a field from a file
# note: awk needs $ quoting, an alternative is this
# $(shell fgrep $(1) $(X_DTS) | cut -d' ' -f2)
define xfld1 =
$(shell awk '$$1 == "'$(1)'" { print $$2 }' $(X_DTS))
endef


## Load the database using a rule
## note: this will not parallelize

$(X_BASE)/in/%.flg0: $(X_TYPE).load.q $(X_BASE)/in/%.csv1
	Qp $+ -bl -bs -savedb $(X_DEST) -savename $(X_TYPE) -saveptn $(call xfld1,$(lastword $+)) -exit
	touch $@

## Set files as targets from the type 

X_SRC0 := $(wildcard $(X_BASE)/in/$(X_TYPE)_*.csv1)
X_TRG0 := $(X_SRC0:csv1=flg0)

load0: $(X_TRG0)

endif

view0:
	-@echo $(X_SRCS)

