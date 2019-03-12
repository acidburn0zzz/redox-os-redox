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

PLATFORM_QEMUFLAGS+=-cpu cortex-a57 -bios $(UBOOT) -device loader,file=build/kernel.uimage,addr=0x41000000,force-raw=on

KLOADADDR=0x40000000
KENTRYADDR=0x40001000

build/livedisk.bin: build/kernel_live
	cp $< $@

kernel.uimage:
	@mkimage -A arm64 -O "linux" -T kernel -C none -a $(KLOADADDR) -e $(KENTRYADDR) -n 'Redox kernel (qemu AArch64 virt)' -d build/kernel_live build/kernel.uimage

bootscript.ram: kernel.uimage
	@$(eval UUID := $(shell cargo run --manifest-path redoxfs/Cargo.toml --release --bin redoxfs -- --get-uuid build/filesystem.bin | awk '{print $$NF}'))
	@$(eval TMPFILE := $(shell mktemp))
	@echo 'setenv bootargs REDOXFS_UUID=$(UUID) ; bootm 41000000 - $${fdtcontroladdr}' > $(TMPFILE)
	@mkimage -A arm64 -T script -C none -n 'Redox Bootscript' -d $(TMPFILE) build/kernel_from_ram.bootscript
	@rm -rf $(TMPFILE)

post_kbuild_platform_hook: bootscript.ram
