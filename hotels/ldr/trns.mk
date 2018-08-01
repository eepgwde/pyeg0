
## weaves

TOP ?= ..

include defs.mk

## Make the target directory - needed early on for paths

all:: $(X_DEST)

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi


## Odd Source files

all:: $(X_SRCS)

# sources for X_EXTS1 and X_EXTS0

# X_EXTS3 - pre-process a CSV or XLS
X_CSVS1 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .csv, $(X_EXTS1)))

view::
\	@echo X_CSVS0 : $(X_CSVS1)

all:: $(X_CSVS1) 

define GOAL_template =
$(X_BASE)/in/$(1): $(X_BASE)/bak/$(1)
	( dos2unix -c mac < $(X_BASE)/bak/$(1); printf "\n" ) > $(X_BASE)/in/$(1)
endef

# These are already CSV

# Straight copies

$(foreach file0,$(notdir $(X_CSVS1)), $(eval $(call GOAL_template,$(file0))))

clean::
	$(SHELL) -c "rm -rf $(X_BASE)/in/*"
