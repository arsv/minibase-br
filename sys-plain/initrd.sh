#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd

cp -at initrd/ boot/*
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

cp -at initrd/lib/modules/$kver $broot/lib/modules/$kver/modules.{builtin,order}
depmod -b initrd $kver
rm initrd/lib/modules/$kver/*.bin

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
