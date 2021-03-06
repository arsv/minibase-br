################################################################################
#
# xf86-video-intel
#
################################################################################

XF86_VIDEO_INTEL_VERSION = b57abe20e81f4b8e4dd203b6a9eda7ff441bc8ce
XF86_VIDEO_INTEL_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-intel
XF86_VIDEO_INTEL_LICENSE = MIT
XF86_VIDEO_INTEL_LICENSE_FILES = COPYING
XF86_VIDEO_INTEL_AUTORECONF = YES

# -D_GNU_SOURCE fixes a getline-related compile error in src/sna/kgem.c
# We force -O2 regardless of the optimization level chosen by the user,
# as compiling this package is known to be broken with -Os.
XF86_VIDEO_INTEL_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE -O2"

XF86_VIDEO_INTEL_CONF_OPTS = \
	--disable-xvmc \
	--enable-sna \
	--disable-xaa \
	--disable-dga \
	--disable-async-swap

XF86_VIDEO_INTEL_DEPENDENCIES = \
	libdrm \
	libpciaccess \
	xlib_libXrandr \
	xproto_fontsproto \
	xproto_xproto \
	xorg-server-wl

# X.org server support for DRI depends on a Mesa3D DRI driver
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri --enable-dri1
# quote from configure.ac: "UXA doesn't build without DRI2 headers"
ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri2 --enable-uxa
else
XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri2 --disable-uxa
endif
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri3
else
XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri3
endif
else
XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri
endif

$(eval $(autotools-package))
