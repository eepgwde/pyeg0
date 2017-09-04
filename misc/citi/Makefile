CXXFLAGS=-O0 -std=c++11 
LDFLAGS=-pthread

TARGETS0 = $(basename $(wildcard *.cpp))

all: $(TARGETS0)

check: $(TARGETS0)
	for i in $+; do $$i; done

clean:
	$(RM) $(TARGETS0)
