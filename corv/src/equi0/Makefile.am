
# prompt> make
# builds everything and links in test program test_rb
#
# prompt> make mem_check
# Rebuilds everything using dmalloc and does memory testing.
# Only works if you have dmalloc installed (see http://dmalloc.com).


AUTOGEN_PROGRAM=$(shell $(AUTOOPTS_CONFIG) --autogen)
AUTOGEN_DATADIR=$(shell $(AUTOOPTS_CONFIG) --pkgdatadir)
AUTOGEN_FLAGS=-L$(AUTOGEN_DATADIR)

AUTOGEN_CFLAGS=$(shell $(AUTOOPTS_CONFIG) --cflags)
AUTOGEN_LDFLAGS=$(shell $(AUTOOPTS_CONFIG) --libs)

# CFLAGS+=$(AUTOGEN_CFLAGS) -DTEST_CHECK_OPTS
# LDFLAGS+=$(AUTOGEN_LDFLAGS)

BUILT_SOURCES = checkopt.c checkopt.h

checkopt.c checkopt.h: checkopt.def

# additional rules
%.c: %.def
	$(AUTOGEN_PROGRAM) $(AUTOGEN_FLAGS) $^

lib_LTLIBRARIES = libequi.la
libequi_la_SOURCES = equi.cpp

noinst_PROGRAMS = equi0

equi0_SOURCES = equi0.cpp checkopt.c
equi0_LDADD = libequi.la
equi0_LDFLAGS = $(AUTOGEN_LDFLAGS)

AM_TESTS_ENVIRONMENT = 
LOG_COMPILER = $(SHELL)
AM_LOG_FLAGS = -x

TESTS = test0.sh
# TESTS = simple_test.sh


