################################################################################
#
# xf86-input-synaptics
#
################################################################################

XF86_INPUT_SYNAPTICS_VERSION = 1.9.0
XF86_INPUT_SYNAPTICS_SOURCE = xf86-input-synaptics-$(XF86_INPUT_SYNAPTICS_VERSION).tar.bz2
XF86_INPUT_SYNAPTICS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XF86_INPUT_SYNAPTICS_LICENSE = MIT
XF86_INPUT_SYNAPTICS_LICENSE_FILES = COPYING
XF86_INPUT_SYNAPTICS_DEPENDENCIES = libevdev xproto_inputproto xproto_randrproto xproto_xproto mtdev
XF86_INPUT_SYNAPTICS_AUTORECONF = YES

$(eval $(autotools-package))
