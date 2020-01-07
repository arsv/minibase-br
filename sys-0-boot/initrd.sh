#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd/bin

mb=../minibase/out/bin
ms=../minibase/out/sys

cp -t initrd/bin $mb/cmd
cp -t initrd/bin $mb/msh
cp -t initrd/bin $mb/list
cp -t initrd/bin $mb/pstree
cp -t initrd/bin $mb/pslist
cp -t initrd/bin $mb/kmount
cp -t initrd/bin $ms/reboot

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

../minibase/out/bin/depmod initrd/lib/modules/$kver

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
