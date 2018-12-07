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
X_CSVS2 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .lst, $(X_EXTS1)))
X_CSVS3 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .re0, $(X_EXTS1)))
X_CSVS4 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .re1, $(X_EXTS1)))

view::
	@echo X_CSVS0 : $(X_CSVS1)

all:: $(X_CSVS1) $(X_CSVS2) $(X_CSVS3) $(X_CSVS4) 

define GOAL_template =
$(X_BASE)/in/$(1): $(X_BASE)/bak/$(1)
	( head -400 $(X_BASE)/bak/$(1); tail -400 $(X_BASE)/bak/$(1) ) > $(X_BASE)/in/$(1)

endef

# These are already CSV

# Split with csplit

$(foreach file0,$(notdir $(X_CSVS1)), $(eval $(call GOAL_template,$(file0))))

## We use csplit to partition the files.

$(X_BASE)/in/%.lst: $(X_BASE)/in/%.csv
	cat $< | $(H_) 2csv splits0 > $@

$(X_BASE)/in/%.re0: $(X_BASE)/in/%.lst
	cat $< | $(H_) 2csv re0 | xargs > $@

$(X_BASE)/in/%.re0: $(X_BASE)/in/%.csv $(X_BASE)/in/%.re0
	cat $< | $(H_) 2csv re0 | xargs > $@

$(X_BASE)/in/%.re1: $(X_BASE)/in/%.csv $(X_BASE)/in/%.re0
	$(H_) 2csv csplit $+
	touch $@



clean::
	$(SHELL) -c "rm -rf $(X_BASE)/in/*"
