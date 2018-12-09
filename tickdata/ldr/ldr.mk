## weaves

TOP = ..

include defs.mk

## all-local:: $(X_DEST) $(X_TARGETS) 

ifeq ($(X_TYPE),)

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi

# Invoke again with type and date file.

define GOAL_template =

all-$(1):
	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) MAKEFILES="$(MAKEFILE_LIST)" X_TYPE=$(1) X_DTS=$(2) load0

all-local:: all-$(1)

endef

X_SRCS = $(wildcard $(X_BASE)/in/*.csv2)

$(foreach file0,$(X_SRCS), \
	$(eval $(call GOAL_template,$(basename $(notdir $(file0))),$(file0))))

# $(X_BASE)/in/%.csv3: $(X_BASE)/in/%.csv2
#	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) MAKEFILES="$(MAKEFILE_LIST)" $@

all-local:: view0

else

## Invoked to load each file
## X_TYPE is type of file estrades or esquote
## X_DTS is the file containing the date for each file

# Extract a field from a file function
define xfld1 =
	$(shell fgrep $(1) $(X_DTS) | cut -d' ' -f2)
endef

## Load the database using a rule
## note: this will not parallelize

$(X_BASE)/in/%.flg0: $(X_TYPE).load.q $(X_BASE)/in/%.csv1
	Qp $+ -bl -bs -savedb $(X_DEST) -savename $(X_TYPE) -saveptn $(call GOAL_template,$(lastword $+)) -exit
	touch $@

## Set files as targets from the type 

X_SRC0 := $(wildcard $(X_BASE)/in/$(X_TYPE)_*.csv1)
X_TRG0 := $(X_SRC0:csv1=flg0)

load0: $(X_TRG0)

endif

view0:
	echo $(X_SRCS)
	echo $(X_BASES)

clean::
	rm -rf $(wildcard $(X_BASE)/in/*)

