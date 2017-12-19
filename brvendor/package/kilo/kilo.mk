################################################################################
#
# kilo
#
################################################################################

KILO_VERSION = 62b099af00b542bdb08471058d527af258a349cf
KILO_SITE = $(call github,antirez,kilo,$(KILO_VERSION))
KILO_LICENSE = BSD-2-Clause
KILO_LICENSE_FILES = LICENSE

define KILO_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define KILO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/kilo $(TARGET_DIR)/bin
endef

$(eval $(generic-package))
