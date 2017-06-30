
all: local-bak intoware.csv m15-6.csv0

local-bak: $(HOME)/Documents/m15-6.xlsx
	cp $< .

intoware.csv: $(HOME)/Documents/intoware.csv
	cp --backup=numbered $< $@

m15-6.csv: $(HOME)/Documents/m15-6.csv
	cp --backup=numbered $< $@

m15-6.csv0: m15-6.csv
	recode latin1..ascii < $< | dos2unix | sed -e 's/\^0//g' -e 's./.,.g' \
-e 's/ .M//g' -e 's/^\(...\) /\1,/g' > $@
