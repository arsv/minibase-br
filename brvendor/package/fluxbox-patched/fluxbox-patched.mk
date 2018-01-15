################################################################################
#
# fluxbox-patched
#
################################################################################

FLUXBOX_PATCHED_VERSION = 1.3.7
FLUXBOX_PATCHED_SOURCE = fluxbox-$(FLUXBOX_PATCHED_VERSION).tar.xz
FLUXBOX_PATCHED_SITE = http://downloads.sourceforge.net/project/fluxbox/fluxbox/$(FLUXBOX_PATCHED_VERSION)
FLUXBOX_PATCHED_LICENSE = MIT
FLUXBOX_PATCHED_LICENSE_FILES = COPYING

FLUXBOX_PATCHED_CONF_OPTS = \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib
FLUXBOX_PATCHED_DEPENDENCIES = xlib_libX11 $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_FREETYPE),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-freetype2
FLUXBOX_PATCHED_DEPENDENCIES += freetype
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-freetype2
endif

ifeq ($(BR2_PACKAGE_IMLIB2_X),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-imlib2
FLUXBOX_PATCHED_DEPENDENCIES += imlib2
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-imlib2
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-fribidi
FLUXBOX_PATCHED_DEPENDENCIES += libfribidi
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-fribidi
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xft
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXft
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xft
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xrender
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXrender
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xrender
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xpm
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXpm
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xpm
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xinerama
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXinerama
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xext
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXext
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xext
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
FLUXBOX_PATCHED_CONF_OPTS += --enable-xrandr
FLUXBOX_PATCHED_DEPENDENCIES += xlib_libXrandr
else
FLUXBOX_PATCHED_CONF_OPTS += --disable-xrandr
endif

define FLUXBOX_PATCHED_INSTALL_FBSETBG
	$(INSTALL) -m 0755 -D \
		$(BR2_EXTERNAL_MINIBASE_PATH)/package/fluxbox-patched/fbsetbg \
		$(TARGET_DIR)/usr/bin/fbsetbg
endef

FLUXBOX_PATCHED_POST_INSTALL_TARGET_HOOKS += FLUXBOX_PATCHED_INSTALL_FBSETBG

$(eval $(autotools-package))
