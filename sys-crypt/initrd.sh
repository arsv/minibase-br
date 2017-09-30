#!/bin/sh

set -e
mkdir -p initrd

cp -at initrd/ dropin/initrd/*
cp -at initrd/ ../minibase/out/boot/sbin

rm initrd/sbin/findblk

kver=4.12.10
kmod=lib/modules/$kver
broot=../buildroot/output/target

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst/char

cp -at initrd/$kmod/kernel $broot/$kmod/kernel/crypto

cp -at initrd/$kmod $broot/$kmod/modules.dep
cp -at initrd/$kmod $broot/$kmod/modules.alias

cp -at $mdst/ $msrc/md
cp -at $mdst/ $msrc/dax
cp -at $mdst/ $msrc/crypto
cp -at $mdst/ $msrc/block
cp -at $mdst/ $msrc/ata
cp -at $mdst/ $msrc/usb
cp -at $mdst/char/ $msrc/char/hw_random

mkdir -p initrd/etc
cp dekeys.nkw initrd/etc/dekeys

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
