CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld


ifeq ($(flag), inc)
	ASFLAGS = -g -defsym opposite=1
	LDFLAGS = -g -static
endif

SRCS = task2.s
OBJS = $(SRCS:.s=.o)

EXE = task2

all: $(SRCS) $(EXE)

.PHONY: clean
clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) -g  $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) -g  $< -o $@
