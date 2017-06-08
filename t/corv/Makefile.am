ACLOCAL_AMFLAGS=-I m4

bin_PROGRAMS=corv
corv_SOURCES=corv.c xmalloc.c system.h aclocal.m4 corv-opt.c corv-opt.h

#  add " -lm" to the following if corv requires the math library
corv_LDADD=-lopts

EXTRA_DIST=corv.lsm.in corv.spec.in corv-opt.def corv.1 manpage.tpl

#  if you write a self-test script named `chk', uncomment the
#  following and add `chk' to the EXTRA_DIST list
#TESTS=chk

corv.o: corv-opt.h
corv-opt.o: corv-opt.c
corv-opt.c corv-opt.h: $(srcdir)/corv-opt.def
	autogen -L/usr/share/autogen $(srcdir)/corv-opt.def

corv.1: $(srcdir)/corv-opt.def
	autogen -T manpage.tpl  $(srcdir)/corv-opt.def
	awk -f updater corv.1 > tmp$$$$ && mv tmp$$$$ corv.1
#	rm updater

# info_TEXINFOS = corv.texinfo
# corv_TEXINFOS = gpl.texinfo

#  install the man page
man_MANS=corv.1
