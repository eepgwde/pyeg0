## weaves

# Date strings aren't consistent with csvguess.q

# Check format is MM/DD/YYYY HH:MM:SS 12/31/1999 08:45:00

# Load cwy fwy rci and others into a q/kdb database.

# The new claims clm has no feature id.
# The old one clm0 has a big overlap.

SHELL := /bin/bash

T_DIR ?= /cache/incoming/hotels

## Should be set by callers
TOP ?= ..

## A helper script uses my m_ arrangement.
H_ = $(TOP)/htl_

X_BASE ?= $(TOP)/cache
X_DEST ?= $(X_BASE)/csvdb

## Used for sftp - it can be: ssh n1 
X_HOST0 ?= 

## Different types of load

### Simple file load directly to master table and stored or mapped directly
X_EXTS1 ?= $(basename $(notdir $(wildcard $(X_BASE)/bak/*.csv)))

view::
	-@echo $(X_EXTS1)
	-@echo $(wildcard $(X_BASE)/bak/*.csv) $(X_SRCS)
	-@echo $(H_)

distclean:: clean

