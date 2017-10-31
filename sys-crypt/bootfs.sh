#!/bin/sh

set -e

source ./whole.map

mkdir -p bootfs/linux

cp initrd.img bootfs/linux/initrd
cp ../buildroot/output/images/bzImage bootfs/linux/kernel
cp dropin/bootfs/syslinux.cfg bootfs/

dd if=/dev/zero of=bootfs.img bs=512 count=$bootsize
mkfs.fat bootfs.img
mmd -i bootfs.img ::/EFI
mmd -i bootfs.img ::/EFI/BOOT
mcopy -i bootfs.img bootfs/* ::
mcopy -i bootfs.img /usr/lib/syslinux/efi64/syslinux.efi ::/EFI/BOOT/BOOTX64.EFI
mcopy -i bootfs.img /usr/lib/syslinux/efi64/ldlinux.e64  ::/EFI/BOOT/ldlinux.e64
syslinux -i bootfs.img
