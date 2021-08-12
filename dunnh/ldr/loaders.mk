## Prep for q/kdb

## We have a new innovation here. There is a file that shortens long field names.
## flds.lst
## A sed script is generated to replace just those fields.

include ../trns/defs.mk 

X_SRCS0 = $(shell cat fls1.lst | xargs)
X_SRCS1 = $(X_SRCS0:.csv=.load1.q)

all: $(X_SRCS1)

view::
	@echo X_SRCS1 $(X_SRCS1)

%.load.q: ../cache/in/%.csv
	Qp -file $+ -z1 -zh -ss -exit -load csvguess.q

%.flst: %.load.q
	$(H_) cols $< > $@

%.sed: %.flst flds.list
	fgrep -F -f $< flds.list | $(H_) sedf > $@

%.load1.q: %.sed %.load.q 
	sed -f $+ > $@

clean::
	-$(RM) $(wildcard *.load1.q *.flst *.sed *.load.q)

