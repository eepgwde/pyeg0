# weaves

X_SRC = cache/bak/data
X_DEST = cache/in

T_FILE ?= $(X_SRC)/rev-transactions.csv

all: $(X_DEST)/transactions.csv2 $(X_DEST)/users.csv0 $(X_DEST)/devices.csv0 $(X_DEST)/notifications.csv0 

# Simplify the record ids to be just integers. This doesn't change the header row.
$(X_DEST)/%.csv0: $(X_SRC)/rev-%.csv
	sed -e '2,$$s/^transaction_//g' -e '2,$$s/user_//g' $< > $@

# Move the city field (#8) to a separate file
$(X_DEST)/transactions.csv1 $(X_DEST)/transactions.csv2: $(X_DEST)/transactions.csv0
	:> $(X_DEST)/transactions.csv1
	gawk -v x0=8 -v d_file=$(X_DEST)/transactions.csv1 -f csv1.awk $< > $(X_DEST)/transactions.csv2
