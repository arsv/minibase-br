#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd/sbin

cp -at initrd/ initrd-dropin/*
cp -at initrd/sbin/ ../minibase/out/sbin/*

mv -t initrd/sbin/ initrd/sbin/system/reboot
rm -fr initrd/sbin/system
rm -fr initrd/sbin/service
rm -f initrd/sbin/wifi
rm -f initrd/sbin/*ctl

kver=4.12.10
kmod=lib/modules/$kver
broot=../brrootfs

msrc=$broot/lib/modules/$kver/kernel/drivers
mdst=initrd/lib/modules/$kver/kernel/drivers

mkdir -p $mdst

cp -at $mdst $msrc/block
cp -at $mdst $msrc/ata
cp -at $mdst $msrc/usb

../minibase/out/sbin/depmod initrd/lib/modules/$kver

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
