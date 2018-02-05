#!/bin/sh

set -e

rm -fr initrd

sdst=initrd/sbin
ssrc=../minibase/out/sbin

mkdir -p $sdst
cp -at $sdst $ssrc/system/findblk
cp -at $sdst $ssrc/system/switchroot
cp -at $sdst $ssrc/system/reboot
cp -at $sdst $ssrc/service/udevmod
cp -at $sdst $ssrc/modprobe
cp -at $sdst $ssrc/runwith
cp -at $sdst $ssrc/kmount
cp -at $sdst $ssrc/msh

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
depmod -b initrd $kver
rm initrd/lib/modules/$kver/*.bin

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
