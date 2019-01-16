ifeq ($(ARCH),)
    $(error "FATAL: ARCH variable not set")
endif

ARCH_CONFIG=mk/arch/$(ARCH).mk

ifeq ("$(wildcard $(ARCH_CONFIG))","")
    $(error "FATAL: The $(ARCH) architecture is not supported")
endif

include $(ARCH_CONFIG)

build/harddrive.bin: build/filesystem.bin
