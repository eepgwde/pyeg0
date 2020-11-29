
X0 = $(PWD)/cache/bak

all-local: $(X0)/data.csv1

$(X0)/data.csv1: $(X0)/data.csv
	sed -e 's/, /,/g' -e 's/,?,/,,/g' -e 's/Not in universe//g' $< | awk -F, 'BEGIN { OFS="," } { sub(/- /, "-", $$NF); printf("%s\n", $$0) }' > $@
