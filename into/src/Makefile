# weaves

S_FILES := intoware0.R intoware3.R caret0.R
T_FILES := $(S_FILES:.R=.Rout)

R_CMD := R CMD BATCH

all: m.img $(T_FILES)

m.img:
	touch $@

intoware0.Rout w.RData: intoware0.R
	$(R_CMD) $<

intoware3.Rout: intoware3.R w.RData
	$(R_CMD) intoware3.R

caret0.Rout: caret0.R intoware3.Rout w.RData
	$(R_CMD) caret0.R

clean:
	-$(RM) $(T_FILES)
	-$(RM) $(wildcard *.jpg)
	-$(RM) m.img m.trace
