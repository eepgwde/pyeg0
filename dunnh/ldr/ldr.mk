## weaves

TOP = ..

include defs.mk

X_SRCS0 = $(shell cat fls1.lst | xargs)
X_SRCS1 = $(X_SRCS0:.csv=.load.q)

X_SPLY = causal trns
X_NSPLY = $(filter-out $(X_SPLY),$(X_EXTS0))

X_TARGETS1 ?= $(addprefix $(X_DEST)/,$(X_SPLY))
X_TARGETS2 ?= $(addprefix $(X_DEST)/,$(X_NSPLY))

all:: $(X_TARGETS1) $(X_TARGETS2)

view::
	@echo X_TARGETS1 $(X_TARGETS1)
	@echo X_TARGETS2 $(X_TARGETS2)

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi

## Rule-based: CSV file name is same as database
## X_EXTS2

## These are quite uniform, but can't define a rule because it would clash
## with the above

define FLOAD_template =
$(X_DEST)/$(1): $(1).load1.q $(X_BASE)/in/$(1).csv 
	Qp $(1).load1.q $(X_BASE)/in/$(1).csv -af -savedb $(X_DEST) -savename $(notdir $(1)) -exit
endef

define LOAD_template =
$(X_DEST)/$(1): $(1).load1.q $(X_BASE)/in/$(1).csv 
	Qp $(1).load1.q $(X_BASE)/in/$(1).csv -bl -bs -savedb $(X_DEST) -savename $(notdir $(1)) -exit
endef

## TODO
## Can use a file loader for some

$(foreach file0,$(X_NSPLY),$(eval $(call FLOAD_template,$(file0))))

$(foreach file0,$(X_SPLY),$(eval $(call LOAD_template,$(file0))))

clean::
	rm -rf $(X_DEST)
