#!/bin/sh

top=..
size="$1"

set -e

if [ -f "NOT-HERE" ]; then
	echo "$0: cannot run in this directory" >&2
	exit 2
elif [ -z "$size" ]; then
	echo "$0: missing argument" >&2
	exit 2
fi

mkdir -p bootfs/linux

cp initrd.img bootfs/linux/initrd
cp $top/buildroot/output/images/bzImage bootfs/linux/kernel
cp $top/common/bootfs/syslinux.cfg bootfs/

dd if=/dev/zero of=bootfs.img bs=512 count=$size
mkfs.fat bootfs.img
mmd -i bootfs.img ::/EFI
mmd -i bootfs.img ::/EFI/BOOT
mcopy -i bootfs.img bootfs/* ::
mcopy -i bootfs.img /usr/lib/syslinux/efi64/syslinux.efi ::/EFI/BOOT/BOOTX64.EFI
mcopy -i bootfs.img /usr/lib/syslinux/efi64/ldlinux.e64  ::/EFI/BOOT/ldlinux.e64
mcopy -i bootfs.img /usr/lib/syslinux/efi32/syslinux.efi ::/EFI/BOOT/BOOTAI32.EFI
mcopy -i bootfs.img /usr/lib/syslinux/efi32/ldlinux.e32  ::/EFI/BOOT/ldlinux.e32
syslinux -i bootfs.img
