#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd

cp -at initrd/ dropin/initrd/*
cp -at initrd/ ../minibase/out/boot/sbin

# not needed for plaintext images
rm initrd/sbin/passblk

kver=4.12.10
kmod=lib/modules/$kver
broot=../buildroot/output/target

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst

cp -at $mdst $msrc/block
cp -at $mdst $msrc/ata
cp -at $mdst $msrc/usb
cp -at initrd/$kmod $broot/$kmod/modules.dep
cp -at initrd/$kmod $broot/$kmod/modules.alias

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
