ifeq ($(UBOOT),)
    $(error "FATAL: Platform $(PLATFORM) requires that UBOOT contain the path to a u-boot binary")
endif

ifeq ("$(wildcard $(UBOOT))","")
    $(error "FATAL: Cannot access a u-boot binary at $(UBOOT)")
endif

QEMU_RAM_SZ=1024
QEMU_MACHINE=virt
PLATFORM_QEMUFLAGS=-cpu cortex-a57 -bios $(UBOOT)
