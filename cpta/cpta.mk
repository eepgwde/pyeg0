X_OUT = cache/out
X_SRC = $(HOME)/Documents

.PHONY: view notebooks


NBS := $(wildcard cpta*.ipynb)
NBS0 := $(NBS:.ipynb=.pdf)

NBXL := $(wildcard $(X_SRC)/cpta*.xlsx)
NBXL0 = $(addprefix $(X_OUT)/,$(notdir $(NBXL)))

TFILE := $(PWD)/cpta.zip

all:: notebooks $(NBXL0)

view:
	-echo $(NBS0)
	-echo $(NBXL)
	-echo $(NBXL0)

notebooks: $(addprefix $(X_OUT)/,$(NBS)) $(addprefix $(X_OUT)/,$(NBS0))

%.pdf: %.ipynb
	jupyter nbconvert --to pdf $<

clean::
	$(RM) $(NBS0)

$(X_OUT)/%.pdf: %.pdf
	cp $< $@

$(X_OUT)/%.xlsx: $(X_SRC)/%.xlsx
	cp $< $@

$(X_OUT)/%.ipynb: %.ipynb
	cp $< $@

all::
	find -L $(X_SRC) -type f -name 'Capita*' | while read i; do cp "$$i" $(X_OUT); done

install-local:
	$(RM) $(wildcard dist/*)
	$(MAKE) MAKEFLAGS=$(MAKEFLAGS) -f Makefile dist-local

install: install-local
