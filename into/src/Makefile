# weaves

# Rscript can pass command-line arguments, but sends all output to a PDF.

S_FILES := intoware0.R intoware3.R caret0.R
T_FILES := $(S_FILES:.R=.Rout)

R_CMD := R CMD BATCH

## This signals the name of the outcome variable via the environment
## Because Rscript doesn't produce our JPEG.

X_OUTCOME ?= Within.Spec
export X_OUTCOME

all: m.img $(T_FILES)

m.img:
	touch $@

intoware0.Rout w.RData: intoware0.R
	$(R_CMD) $< 

intoware3.Rout: intoware3.R w.RData
	$(R_CMD) intoware3.R 

caret0.Rout: caret0.R intoware3.Rout w.RData
	$(R_CMD) caret0.R 

install: zip-images cp-images

zip-images: $(wildcard *.jpg)
	zip $(HOME)/Documents/into0.zip $+

cp-images: $(wildcard *.jpg)
	cp $+ $(HOME)/Documents/into0

clean:
	-$(RM) $(T_FILES)
	-$(RM) $(wildcard *.jpg)
	-$(RM) m.img m.trace
