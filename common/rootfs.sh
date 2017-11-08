#!/bin/sh

set -e
top=..
size="$1"

if [ -f "NOT-HERE" ]; then
	echo "$0: cannot run in this directory" >&2
	exit 2
elif [ -z "$size" ]; then
	echo "$0: missing argument" >&2
	exit 3
fi

mkdir -p rootfs/bin
mkdir -p rootfs/dev
mkdir -p rootfs/mnt
mkdir -p rootfs/proc
mkdir -p rootfs/sys
mkdir -p rootfs/tmp
mkdir -p rootfs/run
mkdir -p rootfs/usr
mkdir -p rootfs/var

mkdir -p rootfs/home/user
mkdir -p rootfs/home/root

broot=$top/buildroot/output/target
cp -at rootfs/ $broot/bin
cp -at rootfs/ $broot/lib
cp -at rootfs/ $broot/usr
cp -at rootfs/ $broot/etc

rm -fr rootfs/etc/udev
rm -fr rootfs/etc/network
rm -f  rootfs/etc/fstab
rm -f  rootfs/etc/hostname
rm -f  rootfs/etc/profile
rm -f  rootfs/etc/shadow
rm -f  rootfs/THIS_IS_NOT_YOUR_ROOT_FILESYSTEM
rm -fr rootfs/usr/lib/udev
ln -sf /run/resolv.conf rootfs/etc/resolv.conf

cp -at rootfs/ $top/common/rootfs/*
cp -at rootfs/ $top/minibase/out/sbin

ln -sf busybox rootfs/bin/sh
rm -f rootfs/var/run; ln -sf /run rootfs/var/run
$top/common/trimfw.sh rootfs

# gets installed suid for whatever reason
chmod u-s rootfs/bin/busybox

rm -f rootfs.img

# mkfs.ext2 needs size in KiB, that's half the number of 512-blocks
fakeroot sh <<END
chown -h -R 0:0 rootfs
chown -R 1:1 rootfs/home/user
mkfs.ext4 -q -d rootfs rootfs.img $((size/2))
END
