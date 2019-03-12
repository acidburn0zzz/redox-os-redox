ifeq ($(PLATFORM),)
    $(error "FATAL: PLATFORM variable not set")
endif

PLATFORM_CONFIG=mk/platform/$(ARCH)/$(PLATFORM).mk

ifeq ("$(wildcard $(PLATFORM_CONFIG))","")
    $(error "FATAL: No $(PLATFORM) platform with arch $(ARCH) is supported")
endif

include $(PLATFORM_CONFIG)
