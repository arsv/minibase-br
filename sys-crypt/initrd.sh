#!/bin/sh

set -e
mkdir -p initrd

cp -at initrd/ dropin/initrd/*
cp -at initrd/ ../minibase/out/boot/bin

rm initrd/bin/findblk

kver=4.12.10
kmod=lib/modules/$kver/kernel/
broot=../buildroot/output/target

mkdir -p initrd/$kmod/drivers/char

cp -at initrd/$kmod/ $broot/$kmod/crypto
cp -at initrd/$kmod/drivers/ $broot/$kmod/drivers/md
cp -at initrd/$kmod/drivers/ $broot/$kmod/drivers/dax
cp -at initrd/$kmod/drivers/ $broot/$kmod/drivers/crypto
cp -at initrd/$kmod/drivers/char/ $broot/$kmod/drivers/char/hw_random
cp -at initrd/lib/modules/$kver $broot/lib/modules/$kver/modules.dep

mkdir -p initrd/etc
cp dekeys.nkw initrd/etc/dekeys

(cd initrd && find . | cpio -oLH newc) | gzip -c > initrd.img
