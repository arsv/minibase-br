#!/bin/sh

set -e

rm -fr ./{bin,etc,lib,usr}
cp -at . ../buildroot/output/target/{bin,etc,lib,usr}
cp -at . ../buildroot/output/images/bzImage

rm -fr etc/network
rm -fr etc/profile.d
rm -f etc/fstab
rm -f etc/hostname
rm -f etc/profile
rm -f etc/shadow
rm -f etc/os-release
rm -f etc/services
rm -f etc/protocols
rm -f etc/issue
rm -f etc/drirc
rm -f THIS_IS_NOT_YOUR_ROOT_FILESYSTEM
rm -f lib/rcrt1.o

ln -sf /run/resolv.conf etc/resolv.conf
#rm -f var/run; ln -sf /run var/run

# udev package is a dependency for X and weston but it never actually
# runs with minibase.
rm -fr etc/udev
rm -fr usr/lib/udev
rm -fr lib/udev
rm -f usr/bin/udevadm

# Some stuff we do not need

rm -fr usr/share/wayland-sessions
rm -fr usr/share/polkit-1
rm -fr usr/share/libdrm
rm -fr usr/share/xml
rm -fr usr/share/fontconfig
rm -fr usr/share/weston/*ivi*
rm -fr usr/lib/python2.7

rm -f usr/lib/xml2Conf.sh
rm -f usr/lib/*.py

rm -f usr/lib64

rm -f usr/libexec/*ivi*

rm -f usr/bin/xmllint     # ?!
rm -f usr/bin/xmlcatalog
rm -f usr/bin/urxvtd      # surprisingly large
rm -f usr/bin/urxvtc
rm -f usr/bin/strace-log-merge

# Weston demos, no need to keep them
mkdir -p usr/bin/tmp
mv -t usr/bin/tmp usr/bin/weston-*
mv -t usr/bin/ usr/bin/tmp/weston-terminal
mv -t usr/bin/ usr/bin/tmp/weston-info
rm -fr usr/bin/tmp

rm -f usr/bin/{cvt,gtf}
rm -f usr/bin/wayland-scanner
rm -f usr/bin/fc-*
rm -f usr/bin/libinput-*
rm -f usr/bin/libevdev-*
rm -f usr/bin/wcap-decode
rm -f usr/bin/mtdev-test
rm -f usr/bin/mouse-dpi-tool
rm -f usr/bin/touchpad-edge-detector

rm -f usr/bin/fluxbox-*
rm -f usr/bin/startfluxbox

# Xorg config is in /etc/X11. The default ones only clutter the logs.
rm -fr usr/share/X11/xorg.conf.d

# XCB protocol description files are HUGE
rm -fr usr/share/xcb

# X core fonts. Lots of unnecessary stuff there.
# The default fixed font is 6x13.
rm -fr usr/share/fonts/X11/encodings/large

misc=usr/share/fonts/X11/misc

rm -fr $misc/12x13*
rm -fr $misc/18x18*
rm -fr $misc/k14*
rm -fr $misc/4x6*
rm -fr $misc/5x7*
rm -fr $misc/5x8*
rm -fr $misc/6x9*
rm -fr $misc/6x10*
rm -fr $misc/6x12*
rm -fr $misc/7x*
rm -fr $misc/8x*
rm -fr $misc/9x15*
rm -fr $misc/10x*

(cd $misc && mkfontdir || true)

unset misc

# Liberation fonts are rather large, and we only maybe need regulars?
# (and even that only for Fluxbox menus)
rm -fr usr/share/fonts/liberation/*-Italic.ttf
rm -fr usr/share/fonts/liberation/*-BoldItalic.ttf

# XKB stuff takes *lots* of space. We only need the bare minimum.
# No way to do it with a simple rm, the goal is to remove everything
# except certain files.
xkb=usr/share/X11/xkb
tmp=$xkb.tmp

cp -a $xkb $tmp
rm -fr $xkb/*/*

cp -t $xkb/compat   $tmp/compat/*
cp -t $xkb/geometry $tmp/geometry/pc
cp -t $xkb/keycodes $tmp/keycodes/{xfree86,evdev,aliases}
cp -t $xkb/rules    $tmp/rules/{base,evdev}
cp -t $xkb/symbols  $tmp/symbols/{empty,latin,compose,group,keypad,terminate}
cp -t $xkb/symbols  $tmp/symbols/{parens,srvr_ctrl,shift,level3,level5,pc,us}
cp -t $xkb/symbols  $tmp/symbols/{capslock,ctrl,eurosign,gb,nbsp,altwin,inet}
cp -t $xkb/types    $tmp/types/*

rm -fr $tmp
unset xkb tmp

# Fluxbox installs lots of rather heavy themes

fls=usr/share/fluxbox/styles
tmp=$fls.tmp

cp -a $fls $tmp
rm -fr $fls
mkdir $fls
cp -at $fls $tmp/bloe # default theme

rm -fr $tmp
unset fls tmp

# Mesa builds two distinct .so libraries: one with all Gallium drivers
# and one with all non-Gallium drivers. They get installed as hard links
# but for this system it's much better to have them as symlinks instead.

nongallium="usr/lib/dri/swrast_dri.so"

for i in usr/lib/dri/*.so; do
	if [ "$i" = "$nongallium" ]; then
		continue
	elif diff -q "$i" "$nongallium" >& /dev/null; then
		ln -sf `basename $nongallium` $i
	fi
done

# linux-firmware installs multiple versions of iwlwifi blobs because reasons.
# We are running a fixed, reasonably recent kernel version so we only need
# the latest blob in each set.
#
#     iwlwifi-8000C-13.ucode <-- drop
#     iwlwifi-8000C-16.ucode <-- drop
#     iwlwifi-8000C-21.ucode <-- drop
#     iwlwifi-8000C-22.ucode <-- drop
#     iwlwifi-8000C-27.ucode <-- drop
#     iwlwifi-8000C-31.ucode <-- drop
#     iwlwifi-8000C-34.ucode <-- keep
#
# These blobs take lots of space (~40MB before trimming) so it is curcial
# to get them out of the image.

cd lib/firmware

last=''
for i in `ls -vr | grep '\.ucode$'`; do
	stem=`echo "$i" | sed -e 's/-[^-]*\.ucode$//'`;

	if [ "$stem" = "$last" ]; then
		rm $i
	else
		last="$stem"
	fi
done
