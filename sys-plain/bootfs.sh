#!/bin/sh

set -e

source ./whole.map

mkdir -p bootfs/linux

cp initrd.img bootfs/linux/initrd
cp ../buildroot/output/images/bzImage bootfs/linux/kernel
cp dropin/bootfs/syslinux.cfg bootfs/

dd if=/dev/zero of=bootfs.img bs=512 count=$bootsize
mkfs.fat bootfs.img
mcopy -oi bootfs.img bootfs/* ::
syslinux -i bootfs.img
