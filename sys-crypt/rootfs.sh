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
cp -at rootfs $broot/etc

rm -fr rootfs/etc/udev
rm -fr rootfs/etc/network
rm -f rootfs/etc/fstab
rm -f rootfs/etc/hostname
rm -f rootfs/etc/profile
rm -f rootfs/etc/shadow
rm -f rootfs/THIS_IS_NOT_YOUR_ROOT_FILESYSTEM
ln -sf /run/resolv.conf rootfs/etc/resolv.conf

cp -at rootfs/ dropin/rootfs/*
cp -at rootfs ../minibase/out/sbin

ln -sf busybox rootfs/bin/sh
rm -f rootfs/var/run; ln -sf /run rootfs/var/run
./trimfw.sh

rm -f rootfs.img

# mkfs.ext2 needs size in KiB, that's half the number of 512-blocks
fakeroot sh <<END
chown -h -R 0:0 rootfs
mkfs.ext4 -d rootfs rootfs.img $((rootsize/2))
END

echo "Encrypting root filesystem"
../minibase/out/sbin/deitool -e rootfs.img rootfs.enc dekeys.nkw 1
