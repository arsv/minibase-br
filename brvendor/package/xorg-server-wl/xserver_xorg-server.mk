################################################################################
#
# xorg-server-wl
#
################################################################################

XORG_SERVER_WL_VERSION = 1.19.6
XORG_SERVER_WL_SOURCE = xorg-server-$(XORG_SERVER_WL_VERSION).tar.bz2
XORG_SERVER_WL_SITE = https://xorg.freedesktop.org/archive/individual/xserver
XORG_SERVER_WL_LICENSE = MIT
XORG_SERVER_WL_LICENSE_FILES = COPYING
XORG_SERVER_WL_INSTALL_STAGING = YES
# xfont_font-util is needed only for autoreconf
XORG_SERVER_WL_AUTORECONF = YES
XORG_SERVER_WL_DEPENDENCIES = \
	libpciaccess \
	libdrm \
	xfont_font-util \
	xutil_util-macros \
	xlib_libX11 \
	xlib_libXau \
	xlib_libXdmcp \
	xlib_libXext \
	xlib_libXfixes \
	xlib_libXi \
	xlib_libXrender \
	xlib_libXres \
	xlib_libXft \
	xlib_libXcursor \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXdamage \
	xlib_libXxf86vm \
	xlib_libxkbfile \
	xlib_libXcomposite \
	xlib_xtrans \
	xdata_xbitmaps \
	xproto_bigreqsproto \
	xproto_compositeproto \
	xproto_damageproto \
	xproto_fixesproto \
	xproto_fontsproto \
	xproto_glproto \
	xproto_inputproto \
	xproto_kbproto \
	xproto_randrproto \
	xproto_renderproto \
	xproto_resourceproto \
	xproto_videoproto \
	xproto_xcmiscproto \
	xproto_xextproto \
	xproto_xf86bigfontproto \
	xproto_xf86dgaproto \
	xproto_xf86vidmodeproto \
	xproto_xproto \
	xproto_dri2proto \
	xproto_presentproto \
	xkeyboard-config \
	pixman \
	mcookie \
	host-pkgconf

# We force -O2 regardless of the optimization level chosen by the
# user, as the X.org server is known to trigger some compiler bugs at
# -Os on several architectures.
XORG_SERVER_WL_CONF_OPTS = \
	--disable-config-hal \
	--disable-xnest \
	--disable-xephyr \
	--disable-dmx \
	--with-builder-addr=buildroot@buildroot.org \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/pixman-1 -O2" \
	--with-fontrootdir=/usr/share/fonts/X11/ \
	--disable-xvfb \
	--enable-weston-launch \
	--enable-libdrm \
	--enable-xorg \
	--enable-composite \
	--disable-kdrive \
	--disable-xfbdev \
	--disable-screensaver

# Xwayland support needs libdrm, libepoxy, wayland and libxcomposite
ifeq ($(BR2_PACKAGE_LIBDRM)$(BR2_PACKAGE_LIBEPOXY)$(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_WAYLAND_PROTOCOLS),yyyy)
XORG_SERVER_WL_CONF_OPTS += --enable-xwayland
XORG_SERVER_WL_DEPENDENCIES += libdrm libepoxy wayland wayland-protocols
else
XORG_SERVER_WL_CONF_OPTS += --disable-xwayland
endif

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
XORG_SERVER_WL_CONF_OPTS += --enable-dri --enable-glx
XORG_SERVER_WL_DEPENDENCIES += mesa3d xproto_xf86driproto
else
XORG_SERVER_WL_CONF_OPTS += --disable-dri --disable-glx
endif

# Optional packages
ifeq ($(BR2_PACKAGE_TSLIB),y)
XORG_SERVER_WL_DEPENDENCIES += tslib
XORG_SERVER_WL_CONF_OPTS += --enable-tslib LDFLAGS="-lts"
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XORG_SERVER_WL_DEPENDENCIES += udev
XORG_SERVER_WL_CONF_OPTS += --enable-config-udev
# udev kms support depends on libdrm and dri2
ifeq ($(BR2_PACKAGE_LIBDRM)$(BR2_PACKAGE_XPROTO_DRI2PROTO),yy)
XORG_SERVER_WL_CONF_OPTS += --enable-config-udev-kms
else
XORG_SERVER_WL_CONF_OPTS += --disable-config-udev-kms
endif
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
XORG_SERVER_WL_DEPENDENCIES += dbus
XORG_SERVER_WL_CONF_OPTS += --enable-config-dbus
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
XORG_SERVER_WL_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
XORG_SERVER_WL_DEPENDENCIES += libunwind
XORG_SERVER_WL_CONF_OPTS += --enable-libunwind
else
XORG_SERVER_WL_CONF_OPTS += --disable-libunwind
endif

ifeq ($(BR2_PACKAGE_XPROTO_RECORDPROTO),y)
XORG_SERVER_WL_DEPENDENCIES += xproto_recordproto
XORG_SERVER_WL_CONF_OPTS += --enable-record
else
XORG_SERVER_WL_CONF_OPTS += --disable-record
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFONT2),y)
XORG_SERVER_WL_DEPENDENCIES += xlib_libXfont2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFONT),y)
XORG_SERVER_WL_DEPENDENCIES += xlib_libXfont
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
XORG_SERVER_WL_CONF_OPTS += --disable-xvmc
endif

ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XORG_SERVER_WL_DEPENDENCIES += xproto_dri2proto
XORG_SERVER_WL_CONF_OPTS += --enable-dri2
else
XORG_SERVER_WL_CONF_OPTS += --disable-dri2
endif
ifeq ($(BR2_PACKAGE_XLIB_LIBXSHMFENCE)$(BR2_PACKAGE_XPROTO_DRI3PROTO),yy)
XORG_SERVER_WL_DEPENDENCIES += xlib_libxshmfence xproto_dri3proto
XORG_SERVER_WL_CONF_OPTS += --enable-dri3
ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGL)$(BR2_PACKAGE_LIBEPOXY),yyy)
XORG_SERVER_WL_DEPENDENCIES += libepoxy
XORG_SERVER_WL_CONF_OPTS += --enable-glamor
else
XORG_SERVER_WL_CONF_OPTS += --disable-glamor
endif
else
XORG_SERVER_WL_CONF_OPTS += --disable-dri3 --disable-glamor
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBDMX),y)
XORG_SERVER_WL_CONF_OPTS += --disable-dmx
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
XORG_SERVER_WL_CONF_OPTS += --with-sha1=libcrypto
XORG_SERVER_WL_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
XORG_SERVER_WL_CONF_OPTS += --with-sha1=libgcrypt
XORG_SERVER_WL_DEPENDENCIES += libgcrypt
else
XORG_SERVER_WL_CONF_OPTS += --with-sha1=libsha1
XORG_SERVER_WL_DEPENDENCIES += libsha1
endif

$(eval $(autotools-package))
