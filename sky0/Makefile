## weaves
# Test make file for weaves module testing.

# Now to be used with conda

PYTHON ?= python
PIP ?= pip
UUT ?= 
FILE ?= test.log
PYTHONIOENCODING=utf-8
DOCSDIR ?= docs/
PKG := $(notdir $(PWD))

NBS ?= $(wildcard *.ipynb)
NBS1 := $(NBS:.ipynb=.py~)
NBS2 := $(NBS:.ipynb=.pdf)

export SDIR

all:: $(NBS1) $(NBS2)
	true

install-local:
	zip walter-eaves README $(NBS) $(NBS2) hi-temp.py july.py outside-temp.py $(wildcard q*.txt)

%.py~: %.ipynb
	jupyter nbconvert --to python $< --stdout > $@

%.pdf: %.ipynb
	jupyter nbconvert --to pdf $< 

ifneq ($(UUT),)

check::
	:> $(FILE)
	$(PYTHON) -m unittest -v tests.$(UUT)

else

check::
	:> $(FILE)
	$(PYTHON) -m unittest discover -v -s tests

endif 

clean::
	$(RM) $(wildcard *.pyc *.log *~ nohup.out)

distclean::
	$(RM) -rf html
	$(RM) $(wildcard *.json)

## Install

.PHONY: uninstall dist-local docs

# --no-private 

docs: 
	rm -rf ${DOCSDIR}
	epydoc -v \
					--no-frames --no-sourcecode --name="weaves-poset" \
					--url="https://github.com/eepgwde/weaves-poset" \
					--inheritance listed --html \
					--graph classtree --show-private --show-imports \
					--css etc/epydoc.css -o ${DOCSDIR} weaves/*.py

uninstall::
	rm -f $(wildcard dist/*.tar.gz)
	-$(SHELL) -c "cd $(HOME)/.local; pip3 uninstall --yes $(PKG)"

dist-local:
	$(PYTHON) setup.py sdist

install: 
	$(PIP) install $(wildcard dist/*.tar.gz)

clean::
	-$(SHELL) -c "find . -type d -name __pycache__ -exec rm -rf {} \;"
	-$(SHELL) -c "find . -type f -name '*.log' -delete "
	-$(SHELL) -c "find . -type f -name '*~' -delete "
	-$(SHELL) -c "find . -type d -name '*egg*' -exec rm -rf {} \; "
	rm -f $(wildcard dist/*) $(NBS1) $(NBS2) $(wildcard 200606.*) $(wildcard q?.txt)
	rm -f walter-eaves.zip
	rm -f ChangeLog AUTHORS
