
X_DIR ?= /cache/incoming/ris

X_SRCS ?= $(wildcard *.ris)
X_SRCS1 ?= $(addprefix $(X_DIR)/, $(X_SRCS))

all: $(X_SRCS1)

all-local:
	ls cache/bak/*.ris | parallel ln -sf {} {%}.ris

$(X_DIR)/%.ris: %.ris
	gawk -f ris0.awk $< > $@

clean-local::
	$(SHELL) -c "rm -f *.ris"
