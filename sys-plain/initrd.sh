#!/bin/sh

set -e

rm -fr initrd
mkdir -p initrd

cp -at initrd/ dropin/initrd/*
cp -at initrd/ ../minibase/out/boot/bin

# not needed for plaintext images
rm initrd/bin/passblk

(cd initrd && find . | cpio -oH newc) | gzip -c > initrd.img
