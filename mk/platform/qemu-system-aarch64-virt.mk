ifeq ($(UBOOT),)
    $(error "FATAL: Platform $(PLATFORM) requires that UBOOT contain the path to a u-boot binary")
endif

ifeq ("$(wildcard $(UBOOT))","")
    $(error "FATAL: Cannot access a u-boot binary at $(UBOOT)")
endif

MKIMAGE := $(shell mkimage -V 2> /dev/null)

ifndef MKIMAGE
    $(error "FATAL: Platform $(PLATFORM) needs mkimage in the path (from the u-boot-tools pkg on Debian derived systems)")
endif

QEMU_RAM_SZ=1024
QEMU_MACHINE=virt
PLATFORM_QEMUFLAGS=-cpu cortex-a57 -bios $(UBOOT)

KLOADADDR=0x40000000
KENTRYADDR=0x40001000

build/livedisk.bin: build/kernel_live
	cp $< $@
