#!/bin/sh

set -e

source ./whole.map

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

broot=../buildroot/output/target
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
rm -fr rootfs/lib/udev
rm -fr rootfs/usr/share/X11/xorg.conf.d
ln -sf /run/resolv.conf rootfs/etc/resolv.conf

cp -at rootfs/ rootfs-dropin/*
cp -at rootfs/ ../minibase/out/sbin

rm -f rootfs/var/run; ln -sf /run rootfs/var/run
./trimfw.sh rootfs

rm -f rootfs.img

# mkfs.ext2 needs size in KiB, that's half the number of 512-blocks
fakeroot sh <<END
chown -h -R 0:0 rootfs
chown -R 1:1 rootfs/home/user
mkfs.ext4 -q -d rootfs rootfs.img $((rootsize/2))
END
