
X0 = $(PWD)/cache/bak
IS = $(wildcard $(X0)/*.csv)
TS = $(IS:.csv=.csv1)

all-local: $(TS)

view-local:
	@echo $(IS)
	@echo $(TS)

## From the source
#
# Simplify spaces after commas are removed
# ? is made an empty cell
# The last field has a space after the - and before the number.

$(X0)/%.csv1: $(X0)/%.csv

	sed -e 's/, /,/g' -e 's/,?,/,,/g' -e 's/Not in universe//g' $< | awk -F, 'BEGIN { OFS="," } { sub(/- /, "-", $$NF); printf("%s\n", $$0) }' > $@


