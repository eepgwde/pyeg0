
## weaves

# Date strings aren't consistent with csvguess.q

# Check format is MM/DD/YYYY HH:MM:SS 12/31/1999 08:45:00

# Load cwy fwy rci and others into a q/kdb database.

# The new claims clm has no feature id.
# The old one clm0 has a big overlap.

SHELL := /bin/bash

T_DIR ?= '/home/host/4/kaggle/dunnhumby_The-Complete-Journey/dunnhumby\ -\ The\ Complete\ Journey\ CSV/'

## Can be set by callers, we use 
# TOP ?= $(shell if test -L $(PWD); then echo ../../../../.. ; else echo ..; fi)

TOP ?= ..

## A helper script uses my m_ arrangement.
H_ = $(TOP)/dunn

X_BASE ?= $(TOP)/cache
X_DEST ?= $(X_BASE)/csvdb

## Used for sftp - it can be: ssh n1 
X_HOST0 ?= 

## Different types of load

### Simple file load directly to master table and stored or mapped directly
X_EXTS0 ?= $(shell cat fls1.lst | sed 's,.csv,,g' | xargs)

X_TARGETS ?= $(addprefix $(X_DEST)/,$(X_EXTS0))

view::
	-@echo X_EXTS0 $(X_EXTS0)
	-@echo X_SRCS $(X_SRCS)
	-@echo X_TARGETS $(X_TARGETS)
	-@echo H_ $(H_)

distclean:: clean

