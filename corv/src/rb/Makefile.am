
# prompt> make
# builds everything and links in test program test_rb
#
# prompt> make mem_check
# Rebuilds everything using dmalloc and does memory testing.
# Only works if you have dmalloc installed (see http://dmalloc.com).

lib_LTLIBRARIES = libredblack.la
libredblack_la_SOURCES = red_black_tree.c stack.c misc.c

noinst_PROGRAMS = redblack
redblack_SOURCES = test_red_black_tree.c 
redblack_LDADD = libredblack.la

AM_TESTS_ENVIRONMENT = 
LOG_COMPILER = $(SHELL)
AM_LOG_FLAGS = -x

TESTS = simple_test.sh



