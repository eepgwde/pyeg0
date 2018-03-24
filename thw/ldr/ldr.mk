## weaves

TOP = ..

include defs.mk

all:: $(X_DEST) $(X_TARGETS) 

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi

## Load the database
## TODO Some names could be simplified and use a rule

$(X_DEST)/%: %.load.q $(X_BASE)/in/%.csv
	Qp $+ -bl -bs -savedb $(X_DEST) -savename $(notdir $@) -exit


clean::
	rm -rf $(X_DEST)
