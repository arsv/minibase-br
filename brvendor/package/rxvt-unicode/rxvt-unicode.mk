################################################################################
#
# rxvt-unicode
#
################################################################################

RXVT_UNICODE_VERSION = 9.22
RXVT_UNICODE_SOURCE = rxvt-unicode-$(RXVT_UNICODE_VERSION).tar.bz2
RXVT_UNICODE_SITE = http://dist.schmorp.de/rxvt-unicode
RXVT_UNICODE_DEPENDENCIES = 
RXVT_UNICODE_LICENSE = GPL
RXVT_UNICODE_LICENSE_FILES = COPYING
RXVT_UNICODE_CONF_OPTS = \
	--enable-256-color \
	--enable-xft \
	--disable-xim \
	--disable-unicode3 \
	--disable-fallback \
	--disable-utmp \
	--disable-wtmp \
	--disable-lastlog \
	--disable-pixbuf \
	--disable-startup-notification \
	--disable-transparency \
	--disable-fading \
	--disable-rxvt-scroll \
	--disable-next-scroll \
	--disable-xterm-scroll \
	--disable-backspace-key \
	--disable-delete-key \
	--disable-swapscreen \
	--disable-iso14755 \
	--enable-text-blink \
	--disable-perl

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
RXVT_UNICODE_DEPENDENCIES += xlib_libXft
RXVT_UNICODE_CONF_OPTS += --enable-xft
else
RXVT_UNICODE_CONF_OPTS += --disable-xft
endif

$(eval $(autotools-package))
