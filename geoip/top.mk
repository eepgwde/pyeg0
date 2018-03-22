## weaves
##
## Top-level makefile

define GOAL_template =
$(3):: 
	$(MAKE) MAKEFLAGS="$(MAKEFLAGS)" -C $(2) -f $(2).mk $(1)
endef

## Set up the links to the remote data.

all:: all-local

all-local:: dirs0 all-local-links

dirs0::
	if ! test -d cache/bak; then mkdir -p cache/bak; fi
	if ! test -d cache/out; then mkdir -p cache/out; fi
	if ! test -d cache/in; then mkdir -p cache/in; fi

dirs1::
	test -d cache/bak
	test -d cache/out
	test -d cache/in

## Install my links.

all-local-links:: archive/local/links.afio
	cd cache/bak; afio -i ../../$+

## Make my links.

dist-local-links: archive/local/links.afio

archive/local/links.afio: cache/bak
	cd cache/bak; find . -maxdepth 1 -type l | afio -o ../../$@

## Build system

all:: dirs1

# others rp

SUBDIRS = trns ldr mkr
RSUBDIRS = $(shell echo $(SUBDIRS) | xargs -n1 | tac | xargs)

## all and clean
## convert, load, then make derivatives, and samples

$(foreach x0,$(SUBDIRS), $(eval $(call GOAL_template,all,$(x0),all)))

$(foreach x0,$(RSUBDIRS), $(eval $(call GOAL_template,clean,$(x0),clean)))


## install and uninstall
## load, then make derivatives, and samples and reports

$(foreach x0,$(filter-out trns, $(SUBDIRS)), $(eval $(call GOAL_template,all,$(x0),all-local)))

$(foreach x0,$(filter-out trns, $(RSUBDIRS)), $(eval $(call GOAL_template,clean,$(x0),clean-local)))


$(foreach x0,$(lastword $(SUBDIRS)), $(eval $(call GOAL_template,install-local,$(x0),install)))

$(foreach x0,$(firstword $(RSUBDIRS)), $(eval $(call GOAL_template,uninstall-local,$(x0),uninstall)))

view3:
	echo $(lastword $(SUBDIRS))


## dist
## generate final CSV files

$(foreach x0,bldr, $(eval $(call GOAL_template,install,$(x0),dist)))

