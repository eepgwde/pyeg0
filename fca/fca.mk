X_OUT = cache/out
X_SRC = $(HOME)/Documents

.PHONY: view notebooks dir0 dir1

NBS := $(wildcard fca?.ipynb)
NBS0 := $(NBS:.ipynb=.pdf)

NBXL := $(wildcard $(X_SRC)/fca?.xlsx)
NBXL0 = $(addprefix $(X_OUT)/,$(notdir $(NBXL)))

TFILE := $(PWD)/fca.zip

# $(NBXL0)
all:: dir1 notebooks

dir0:
	test -d cache || mkdir cache
	test -d cache/bak || ( cd cache ; ln -s /cache/incoming/fca bak )

all-local:: dir0 in.csv

in.csv: 
	ln -s cache/bak/bank-direct-marketing.csv in.csv

dir1:
	test -d $(X_OUT) || mkdir -p $(X_OUT)

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
