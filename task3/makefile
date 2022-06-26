CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

SRCS = task3.s
OBJS = $(SRCS:.s=.o)

EXE = task3

all: $(SRCS) $(EXE)

.PHONY: clean
clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD)  -g -static $(OBJS) -o $@

.s.o:
	$(AS)  -g  $< -o $@
