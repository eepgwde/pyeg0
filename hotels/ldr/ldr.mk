## weaves

TOP = ..

include defs.mk

X_SRCS ?= $(wildcard $(X_BASE)/in/*.csv)
X_TARGETS ?= $(addprefix $(X_DEST)/, $(basename $(notdir $(X_SRCS))))

all:: $(X_DEST) $(X_TARGETS) 

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi

view::
	-@echo X_SRCS $(X_SRCS)
	-@echo X_TARGETS $(X_TARGETS)

## Load the database
## TODO Some names could be simplified and use a rule

$(X_DEST)/%: %.load.q $(X_BASE)/in/%.csv
	Qp $+ -bl -bs -savedb $(X_DEST) -savename $(notdir $@) -exit


clean::
	rm -rf $(X_DEST)
