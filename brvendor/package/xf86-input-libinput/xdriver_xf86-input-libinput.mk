################################################################################
#
# xf86-input-libinput
#
################################################################################

XF86_INPUT_LIBINPUT_VERSION = 0.25.1
XF86_INPUT_LIBINPUT_SOURCE = xf86-input-libinput-$(XF86_INPUT_LIBINPUT_VERSION).tar.bz2
XF86_INPUT_LIBINPUT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XF86_INPUT_LIBINPUT_LICENSE = MIT
XF86_INPUT_LIBINPUT_LICENSE_FILES = COPYING
XF86_INPUT_LIBINPUT_DEPENDENCIES = libinput xorg-server-wl xproto_inputproto xproto_xproto
XF86_INPUT_LIBINPUT_AUTORECONF = YES

$(eval $(autotools-package))
