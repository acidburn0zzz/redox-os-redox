ifeq ($(PLATFORM),)
    $(error "FATAL: PLATFORM variable not set")
endif

PLATFORM_CONFIG=mk/platform/$(PLATFORM).mk

ifeq ("$(wildcard $(PLATFORM_CONFIG))","")
    $(error "FATAL: The $(PLATFORM) platform is not supported")
endif

include $(PLATFORM_CONFIG)
