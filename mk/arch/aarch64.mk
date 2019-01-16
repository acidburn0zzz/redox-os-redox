build/bootloader:
	mkdir -p build
	touch $@

build/live.o: build/filesystem.bin
	export PATH="$(PREFIX_PATH):$$PATH" && \
	$(OBJCOPY) -I binary -O elf64-littleaarch64 -B aarch64 $< $@ \
		--redefine-sym _binary_build_filesystem_bin_start=__live_start \
		--redefine-sym _binary_build_filesystem_bin_end=__live_end \
		--redefine-sym _binary_build_filesystem_bin_size=__live_size
