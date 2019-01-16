build/bootloader: bootloader/$(ARCH)/**
	mkdir -p build
	nasm -f bin -o $@ -D ARCH_$(ARCH) -ibootloader/$(ARCH)/ bootloader/$(ARCH)/disk.asm

build/harddrive.bin: build/filesystem.bin bootloader/$(ARCH)/**
	nasm -f bin -o $@ -D ARCH_$(ARCH) -D FILESYSTEM=$< -ibootloader/$(ARCH)/ bootloader/$(ARCH)/disk.asm

build/livedisk.bin: build/kernel_live bootloader/$(ARCH)/**
	nasm -f bin -o $@ -D ARCH_$(ARCH) -D KERNEL=$< -ibootloader/$(ARCH)/ bootloader/$(ARCH)/disk.asm

build/live.o: build/filesystem.bin
	#TODO: More general use of $(ARCH)
	export PATH="$(PREFIX_PATH):$$PATH" && \
	$(OBJCOPY) -I binary -O elf64-x86-64 -B i386:x86-64 $< $@ \
		--redefine-sym _binary_build_filesystem_bin_start=__live_start \
		--redefine-sym _binary_build_filesystem_bin_end=__live_end \
		--redefine-sym _binary_build_filesystem_bin_size=__live_size
