
TARGETS ?= hexp-065.csv1 csvdb/hexp

all: $(TARGETS)

hexp-065.csv1: ../bak/hexp-065.csv pru0.R
	R BATCH -f pru0.R

csvdb/hexp: hexp-065.csv1 hexp065.load.q 
	rm -rf csvdb
	Qp -load hexp065.load.q hexp-065.csv1 -bl -bs -savename hexp -exit

