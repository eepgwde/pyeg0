# weaves

X_SRC = cache/bak/data
X_DEST = cache/in

X_DB = csvdb

T_FILE ?= $(X_SRC)/rev-transactions.csv

all: $(X_DEST)/transactions.csv2 $(X_DEST)/users.csv0 $(X_DEST)/devices.csv0 $(X_DEST)/notifications.csv0 $(X_DEST)/users.csv1 $(X_DEST)/users.csv2

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

install-local:
	@for i in anal0.q ldr0.q; do echo $$i $$(egrep -v '^(//|/ |$$)' $$i | wc -l); done


## Cleaning

distclean:: clean
	-$(SHELL) -c "rm -rf $(X_DB)/*"
