
TARGETS ?= hexp0-065.csv csvdb/hexp

all: $(TARGETS)

hexp0-065.csv: ../bak/hexp-065.csv pru0.R
	R BATCH -f pru0.R

csvdb/hexp: hexp0-065.csv hexp065.load.q 
	rm -rf csvdb
	Qp -load hexp065.load.q -file hexp0-065.csv -bl -bs -savename hexp -exit

