## weaves
##
## Make the derivative tables

TOP = ..

include $(TOP)/ldr/defs.mk

## The $(PWD) is from the parent make in the directory above.
xPWD := $(shell pwd)

## Make derivative tables
X_DERIVS ?= kipv4 ken mipv4

## TODO dfct1 samples1 

X_DERIVS1 = $(addprefix $(X_DEST)/, $(X_DERIVS) )

all:: all-local $(X_DERIVS1)

## Install references

X_CSVS = $(wildcard *.csv)
X_CSVS1 = $(addprefix $(X_BASE)/, $(X_CSVS))

view2:
	echo $(xPWD)
	echo $(X_CSVS)
	echo $(X_CSVS1)

all-local: $(X_DEST)/geoip.q $(X_CSVS1)

$(X_DEST)/geoip.q: geoip.q
	if ! test -L $@; then cd $(X_DEST); ln -s $(xPWD)/geoip.q .; fi

$(X_BASE)/in/%.csv: %.csv
	if ! test -L $@; then cd $(X_BASE)/in; ln -s $(xPWD)/$< . ; fi

## Write serialized table files in csvdb

## rci1 and cwy0 are the main tables.

$(X_DEST)/kipv4 $(X_DEST)/mipv4 $(X_DEST)/ken : geoip1.q $(X_DEST)/ipv4 $(X_DEST)/en
	Qp -load "$(X_DEST) geoip1.q"

install:: install-local

install-local:: u.qserve

X_Q ?= Qp
Q_SRV ?= geoip
Q_SRV_PRT ?= 4444

export sName=$(Q_SRV)
export sN=0

u.qserve: geop-wip.q
	screen -dmS $(sName)
	screen -S $(sName) -X eval "screen $(sN)"
	screen -S $(sName) -X eval "title $(Q_SRV)"
	screen -S $(sName) -X stuff "$(X_Q) -p $(Q_SRV_PRT) -load $(X_DEST) $(xPWD)/geop-wip.q \n"

uninstall: uninstall-local

uninstall-local:: x.qserve

x.qserve:
	m_ -f $(sName) screen x-kill-all
	rm -f qserve.flag

clean::
	rm -f $(X_SUPPORT)

clean::
	rm -f $(X_DERIVS1)

## $(SHELL) -c "rm -rf out/*"
