#!/bin/sh

set -e
mkdir -p initrd

sdst=initrd/sbin
ssrc=../minibase/out/sbin

mkdir -p $sdst
cp -at $sdst $ssrc/system/passblk
cp -at $sdst $ssrc/system/switchroot
cp -at $sdst $ssrc/system/reboot
cp -at $sdst $ssrc/service/udevmod
cp -at $sdst $ssrc/modprobe
cp -at $sdst $ssrc/runwith
cp -at $sdst $ssrc/kmount
cp -at $sdst $ssrc/msh

cp -at initrd/ boot/*

kver=4.12.10
kmod=lib/modules/$kver
broot=../buildroot/output/target

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst/char

cp -at initrd/$kmod/kernel $broot/$kmod/kernel/crypto

cp -at $mdst/ $msrc/md
cp -at $mdst/ $msrc/dax
cp -at $mdst/ $msrc/crypto
cp -at $mdst/ $msrc/block
cp -at $mdst/ $msrc/ata
cp -at $mdst/ $msrc/usb
cp -at $mdst/char/ $msrc/char/hw_random

cp -at initrd/lib/modules/$kver $broot/lib/modules/$kver/modules.{builtin,order}
depmod -b initrd $kver
rm initrd/lib/modules/$kver/*.bin

mkdir -p initrd/etc
cp dekeys.nkw initrd/etc/dekeys

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
