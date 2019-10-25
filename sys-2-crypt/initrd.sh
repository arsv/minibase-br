#!/bin/sh

set -e
mkdir -p initrd

sdst=initrd/sbin
ssrc=../minibase/out/sbin

mkdir -p $sdst
cp -at $sdst $ssrc/system/devinit
cp -at $sdst $ssrc/system/passblk
cp -at $sdst $ssrc/system/findblk
cp -at $sdst $ssrc/system/switchroot
cp -at $sdst $ssrc/system/reboot
cp -at $sdst $ssrc/cmd
cp -at $sdst $ssrc/dmesg
cp -at $sdst $ssrc/ls
cp -at $sdst $ssrc/modprobe
cp -at $sdst $ssrc/kmount
cp -at $sdst $ssrc/msh

cp -at initrd/ initrd-dropin/*

kver=4.12.10
kmod=lib/modules/$kver
broot=../brrootfs

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

if [ ! -f dekeys.nkw ]; then
	echo "Run ./rootfs.sh first" >&2
	exit 1
fi

mkdir -p initrd/etc
cp dekeys.nkw initrd/etc/keys.bin

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
