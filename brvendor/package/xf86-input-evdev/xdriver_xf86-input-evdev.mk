################################################################################
#
# xf86-input-evdev
#
################################################################################

XF86_INPUT_EVDEV_VERSION = 2.10.5
XF86_INPUT_EVDEV_SOURCE = xf86-input-evdev-$(XF86_INPUT_EVDEV_VERSION).tar.bz2
XF86_INPUT_EVDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XF86_INPUT_EVDEV_LICENSE = MIT
XF86_INPUT_EVDEV_LICENSE_FILES = COPYING
XF86_INPUT_EVDEV_AUTORECONF = YES

XF86_INPUT_EVDEV_DEPENDENCIES = \
	host-pkgconf \
	libevdev \
	mtdev \
	xproto_inputproto \
	xorg-server-wl \
	xproto_randrproto \
	xproto_xproto \
	udev

$(eval $(autotools-package))
