## weaves

# Date strings aren't consistent with csvguess.q

# Check format is MM/DD/YYYY HH:MM:SS 12/31/1999 08:45:00

# Load cwy fwy rci and others into a q/kdb database.

# The new claims clm has no feature id.
# The old one clm0 has a big overlap.

SHELL := /bin/bash

T_DIR ?= /cache/incoming/geoip

## Should be set by callers
TOP ?= ..

## A helper script uses my m_ arrangement.
H_ = $(TOP)/geoip_

X_BASE ?= $(TOP)/cache
X_DEST ?= $(X_BASE)/csvdb

## Used for sftp - it can be: ssh n1 
X_HOST0 ?= 

## Different types of load

### Simple file load directly to master table and stored or mapped directly
X_EXTS1 ?= br cn de en es fr ipv4 ipv6 ja ru

X_TARGETS ?= $(addprefix $(X_DEST)/,$(X_EXTS1))

view::
	-@echo $(X_SRCS)
	-@echo $(X_TARGETS)
	-@echo $(H_)

distclean:: clean

