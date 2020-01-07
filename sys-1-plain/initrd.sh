#!/bin/sh

set -e

rm -fr initrd

sdst=initrd/bin
mb=../minibase/out/bin
ms=../minibase/out/sys

mkdir -p $sdst
cp -at $sdst $ms/findblk
cp -at $sdst $ms/switchroot
cp -at $sdst $ms/reboot
cp -at $sdst $ms/devinit
cp -at $sdst $mb/msh
cp -at $sdst $mb/modprobe
cp -at $sdst $mb/kmount

cp -at initrd/ initrd-dropin/*

kver=4.12.10
kmod=lib/modules/$kver
broot=../brrootfs

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst

cp -at $mdst $msrc/block
cp -at $mdst $msrc/ata
cp -at $mdst $msrc/usb

cp -at initrd/lib/modules/$kver $broot/lib/modules/$kver/modules.{builtin,order}
../minibase/out/bin/depmod initrd/lib/modules/$kver

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
