## weaves

TOP ?= ..

include defs.mk

## Make the target directory - needed early on for paths

all-local:: $(X_DEST)

$(X_DEST):
	if ! test -d $(X_DEST); then mkdir $(X_DEST); fi


## Odd Source files

all-local:: $(X_SRCS)

# sources for X_EXTS1 and X_EXTS0

# X_EXTS3 - pre-process a CSV or XLS
X_CSVS1 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .csv, $(X_EXTS1)))
X_CSVS2 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .lst, $(X_EXTS1)))
X_CSVS3 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .re0, $(X_EXTS1)))
X_CSVS4 ?= $(addprefix $(X_BASE)/in/, $(addsuffix .re1, $(X_EXTS1)))

view::
	@echo X_CSVS0 : $(X_CSVS1)

all-local:: $(X_CSVS1) $(X_CSVS2) $(X_CSVS3) $(X_CSVS4) 

## These are already CSV
# But very big, need to use csplit

# Test GOAL

define GOAL1_template =

$(X_BASE)/in/$(1): $(X_BASE)/bak/$(1)
	( head -400 $(X_BASE)/bak/$(1); tail -400 $(X_BASE)/bak/$(1) ) > $(X_BASE)/in/$(1)

endef

# Prod GOAL

LN = ln

## in/ and bak/ must be siblings
$(X_BASE)/in/%.csv: $(X_BASE)/bak/%.csv
	cd $(dir $@); $(LN) -sf ../bak/$(notdir $<) .

define GOAL_template =
X_BASES += $(X_BASE)/in/$(1)
endef

$(foreach file0,$(notdir $(X_CSVS1)), $(eval $(call GOAL_template,$(file0))))

all-local:: $(X_BASES)

## We use csplit to partition the files.

$(X_BASE)/in/%.lst: $(X_BASE)/in/%.csv
	cat $< | $(H_) 2csv splits0 > $@

$(X_BASE)/in/%.re0: $(X_BASE)/in/%.lst
	cat $< | $(H_) 2csv re0 | xargs > $@

$(X_BASE)/in/%.re0: $(X_BASE)/in/%.csv $(X_BASE)/in/%.re0
	cat $< | $(H_) 2csv re0 | xargs > $@

$(X_BASE)/in/%.re1: $(X_BASE)/in/%.csv $(X_BASE)/in/%.re0
	$(H_) $(HFLAGS) 2csv csplit $+
	touch $@

## Rejoin
# $(X_BASE)/in/$(1): $(X_BASE)/bak/$(1)

# This file is the control file for ldr.mk

$(X_BASE)/in/%.csv2: $(X_BASE)/in/%_00.csv
	$(H_) $(HFLAGS) -s .csv1 -f $< 2csv bundle $(filter-out $<, $(wildcard $(basename $@)_??.csv)) > $@

define SPEC_template =

X_TARGETS0 += $(X_BASE)/in/$(1).csv2

endef

## Build some stems and use a function
# The function is just there for illustration.

X_T00s := $(basename $(notdir $(X_CSVS1)))

$(foreach file0,$(X_T00s), $(eval $(call SPEC_template,$(file0))))

view0:
	@echo X_CSVS1 $(X_CSVS1)
	@echo X_TARGETS0 $(X_TARGETS0)
	echo $(X_OBJS) $(X_BASE) $(TAGS)

all-local1: $(X_TARGETS0)

all: all-local
	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) MAKEFILES="$(MAKEFILE_LIST)" all-local1

clean::
	$(SHELL) -c "rm -rf $(X_BASE)/in/*"
