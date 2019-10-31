# weaves

X_SRC = cache/bak/data
X_DEST = cache/in

X_SRCS0 ?= $(subst rev-,,$(wildcard cache/bak/data/rev-*.csv))
X_SRCS = $(addprefix $(X_DEST)/,$(notdir $(X_SRCS0:.csv=.csv2)))

X_DB = csvdb

T_FILE ?= $(X_SRC)/rev-transactions.csv

view:
	@echo X_SRCS0 : $(X_SRCS0)
	@echo X_SRCS : $(X_SRCS)

all: $(X_SRCS)

# Simplify the record ids to be just integers. This doesn't change the header row.
$(X_DEST)/%.csv0: $(X_SRC)/rev-%.csv
	sed -e '2,$$s/^transaction_//g' -e '2,$$s/user_//g' $< > $@

# Move the city field (#8) to a separate file
$(X_DEST)/transactions.csv1 $(X_DEST)/transactions.csv2: $(X_DEST)/transactions.csv0
	:> $(X_DEST)/transactions.csv1
	gawk -v x0=8 -v d_file=$(X_DEST)/transactions.csv1 -f csv1.awk $< > $(X_DEST)/transactions.csv2

$(X_DEST)/users.csv1 $(X_DEST)/users.csv2: $(X_DEST)/users.csv0
	:> $(X_DEST)/users.csv1
	gawk -v x0=4 -v d_file=$(X_DEST)/users.csv1 -f csv1.awk $< > $(X_DEST)/users.csv2

$(X_DEST)/devices.csv2: $(X_DEST)/devices.csv0
	cd $(X_DEST); ln -s $(notdir $<) $(notdir $@)

$(X_DEST)/notifications.csv2: $(X_DEST)/notifications.csv0
	cd $(X_DEST); ln -s $(notdir $<) $(notdir $@)


all-local: devices.load.q  notifications.load.q  transactions.load.q  users.load.q

%.load.q: $(X_DEST)/%.csv2
	Qp ~/share/qsys/csvguess.q 

clean::
	$(SHELL) -c "rm -rf $(X_DEST)/*"

## Load to csvdb

$(X_DB)/users: $(X_DEST)/users.csv2
	Qp users.load.q $< csvdb -bl -bs -savedb $(X_DB) -savename users -exit

$(X_DB)/transactions: $(X_DEST)/transactions.csv2
	Qp transactions.load.q $< csvdb -bl -bs -savedb $(X_DB) -savename transactions -exit

$(X_DB)/devices: $(X_DEST)/devices.csv0
	Qp devices.load.q $< csvdb -bl -bs -savedb $(X_DB) -savename devices -exit

$(X_DB)/notifications: $(X_DEST)/notifications.csv0
	Qp notifications.load.q $< csvdb -bl -bs -savedb $(X_DB) -savename notifications -exit

install: $(X_DB)/notifications $(X_DB)/devices $(X_DB)/transactions $(X_DB)/users

.PHONY: dist-local ncode-work nzip csv-info distclean

dist-local:: ncode-work code-work.txt

ncode-work:
	$(RM) code-work.txt

code-work.txt:: 
	@for i in $(wildcard anal?.q ldr0.q); do echo $$i $$(egrep -v '^(//|/ |$$)' $$i | wc -l); done >> $@

code-work.txt:: 
	for i in $(wildcard anal?.ipynb); do echo $${i}:; jupyter nbconvert --stdout --to script $$i 2> /dev/null | egrep -v '^(#|$$)' | wc -l; done | xargs -n2  >> code-work.txt

X_IPYNB ?= $(wildcard anal?.ipynb pgsql.ipynb)
X_IPYNB1 := $(X_IPYNB:.ipynb=.html)
X_TGT ?= walter_eaves_ht.zip

dist-local:: nzip csv-info $(X_TGT)

nzip:
	rm -f $(X_TGT)

$(X_TGT):: files.txt
	@cat $+ | zip -u -@ $(X_TGT)

%.html: %.ipynb
	jupyter nbconvert --to html $<

csv-info:: csv-headers.txt csvdb-headers.txt

csv-headers.txt:
	export d_sep="," ; for i in $(wildcard cache/bak/data/*.csv); do echo $$(basename $$i) ; m_ -c 2 info headerlist $$i; done | unix2dos > $@

csvdb-headers.txt:
	cat $$(wildcard *.load.q) | egrep '^LOADHDRS' | unix2dos > $@

$(X_TGT):: $(X_IPYNB1) csv-headers.txt csvdb-headers.txt code-work.txt rvlt/*.py
	zip -u $@ $+

## Cleaning

distclean:: clean
	$(SHELL) -c "rm -rf $(X_DB)/*"
	-$(RM) $(X_IPYNB1) csv-headers.txt csvdb-headers.txt $(wildcard *.log)
