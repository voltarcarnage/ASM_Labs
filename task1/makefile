AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
CUR_PATH = $(shell pwd)
CUR_DIR = $(shell basename $(CUR_PATH))
RUN = qemu-aarch64 $(CUR_DIR).out

.PHONY: default
default: build

build: *.s
	$(AS) -g -o $(CUR_DIR).o *.s
	$(LD) -g -static -o $(CUR_DIR).out $(CUR_DIR).o

.PHONY: clean
clean:
	@-rm *.o *.out

.PHONY: run
run:
	@$(RUN)
