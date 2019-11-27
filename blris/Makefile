
X_SRCS ?= $(wildcard *.ris)
X_SRCS1 := $(X_SRCS:.ris=.ris0)
X_SRCS2 := $(X_SRCS:.ris=.ris3)

X_DIR := /cache/incoming/ris/
X_DST ?= $(shell mktemp --tmpdir=/cache/incoming/ris/ --suffix=.ris)

view:
	echo $(X_DST)

.PHONY: target-local

## For trace
# .PRECIOUS: %.ris0 %.ris0 %.ris1 %.ris2 %.ris3

all: $(X_SRCS1) $(X_SRCS2) target-local

all-local:
	ls cache/bak/*.ris | parallel ln -sf {} {#}.ris

%.ris0: %.ris
	gawk -f ris0.awk $< > $@

%.ris1: %.ris0
	gawk -f ris1.awk $< > $@

%.ris2: %.ris1
	gawk -f ris2.awk $< > $@

%.ris3: %.ris2
	gawk -f ris3.awk $< > $@

target-local: $(X_SRCS2)
	cat $+ > $(X_DST)

clean-local::
	$(SHELL) -c "rm -f *.ris*"

clean:: clean-local
	$(SHELL) -c "rm -f $(X_DIR)/*.ris"
