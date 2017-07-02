# weaves

S_FILES := intoware0.R intoware3.R
T_FILES := $(S_FILES:.R=.Rout)

all: m.img corr-01.jpg $(T_FILES)

m.img:
	touch $@

intoware0.Rout w.RData: intoware0.R
	R CMD BATCH $<

intoware3.Rout: intoware3.R w.RData
	R CMD BATCH intoware3.R

clean:
	-$(RM) $(T_FILES)
	-$(RM) m.img m.trace
