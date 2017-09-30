#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd

cp -at initrd/ dropin/*
cp -at initrd/ ../minibase/out/boot/sbin
cp -at initrd/sbin ../minibase/out/sbin/dmesg

rm initrd/sbin/passblk

broot=../buildroot/output/target

mkdir -p initrd/lib
cp -at initrd/lib/ $broot/lib/*.so*
cp -at initrd/ $broot/bin
chmod 0755 initrd/bin/busybox

kver=4.12.10
kmod=lib/modules/$kver
broot=../buildroot/output/target

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst

cp -at $mdst $msrc/block
cp -at $mdst $msrc/ata
cp -at $mdst $msrc/usb
cp -at initrd/$kmod $broot/$kmod/modules.alias
cp -at initrd/$kmod $broot/$kmod/modules.dep

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
