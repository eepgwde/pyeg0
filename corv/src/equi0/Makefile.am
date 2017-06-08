
# prompt> make
# builds everything and links in test program test_rb
#
# prompt> make mem_check
# Rebuilds everything using dmalloc and does memory testing.
# Only works if you have dmalloc installed (see http://dmalloc.com).

lib_LTLIBRARIES = libequi.la
libequi_la_SOURCES = equi.cpp

noinst_PROGRAMS = equi0

equi0_SOURCES = equi0.cpp
equi0_LDADD = libequi.la

AM_TESTS_ENVIRONMENT = 
LOG_COMPILER = $(SHELL)
AM_LOG_FLAGS = -x

TESTS = test0.sh
# TESTS = simple_test.sh



