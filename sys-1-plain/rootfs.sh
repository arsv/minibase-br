#!/bin/sh

set -e

source ./whole.map

rm -fr rootfs

mkdir -p rootfs/base/bin
mkdir -p rootfs/base/sys
mkdir -p rootfs/base/etc
mkdir -p rootfs/bin
mkdir -p rootfs/dev
mkdir -p rootfs/mnt
mkdir -p rootfs/proc
mkdir -p rootfs/sys
mkdir -p rootfs/tmp
mkdir -p rootfs/run
mkdir -p rootfs/usr
mkdir -p rootfs/var
mkdir -p rootfs/home

rm -f rootfs/var/run; ln -sf /run rootfs/var/run

cp -at rootfs/ ../brrootfs/{bin,etc,lib,usr}
cp -at rootfs/base ../minibase/out/bin
cp -at rootfs/base ../minibase/out/sys
cp -at rootfs/ rootfs-dropin/*

rm rootfs/etc/passwd
rm rootfs/etc/group

rm -f rootfs.img

# mkfs.ext2 needs size in KiB, that's half the number of 512-blocks
fakeroot sh <<END
chown -h -R 0:0 rootfs
chown -R 1:1 rootfs/home
mkfs.ext4 -m 0 -q -d rootfs rootfs.img $((rootsize/2))
END
