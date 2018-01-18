#!/bin/sh

set -e

source ./whole.map

rm -fr bootfs
mkdir -p bootfs/linux

cp initrd.img bootfs/linux/initrd
cp ../brrootfs/bzImage bootfs/linux/kernel
cp bootfs-dropin/syslinux.cfg bootfs/

img=bootfs.img

dd if=/dev/zero of=$img bs=512 count=$bootsize status=none

syslinux=/usr/lib/syslinux

mkfs.fat $img
mmd -i $img ::/EFI
mmd -i $img ::/EFI/BOOT
mcopy -i $img bootfs/* ::
mcopy -i $img $syslinux/efi64/syslinux.efi ::/EFI/BOOT/BOOTX64.EFI
mcopy -i $img $syslinux/efi64/ldlinux.e64  ::/EFI/BOOT/ldlinux.e64
mcopy -i $img $syslinux/efi32/syslinux.efi ::/EFI/BOOT/BOOTAI32.EFI
mcopy -i $img $syslinux/efi32/ldlinux.e32  ::/EFI/BOOT/ldlinux.e32

syslinux -i $img
