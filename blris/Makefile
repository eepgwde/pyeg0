
X_DIR ?= /cache/incoming/ris

X_SRCS ?= $(wildcard *.ris)
X_SRCS1 := $(X_SRCS:.ris=.ris0)
X_SRCS2 := $(X_SRCS:.ris=.ris1)
# X_SRCS1 ?= $(addprefix $(X_DIR)/, $(X_SRCS))

all: $(X_SRCS1) $(X_SRCS2)

all-local:
	ls cache/bak/*.ris | parallel ln -sf {} {%}.ris

%.ris0: %.ris
	gawk -f ris0.awk $< > $@

%.ris1: %.ris0
	gawk -f ris1.awk $< > $@

clean-local::
	$(SHELL) -c "rm -f *.ris*"

clean:: clean-local
	$(SHELL) -c "rm -f $(X_DIR)/*.ris"
