#!/bin/sh

set -e

source ./whole.map

syslinux=/usr/lib/syslinux

dd of=whole.img if=/dev/zero bs=512 count=$totalsize status=none
dd of=whole.img if=$syslinux/bios/mbr.bin conv=notrunc status=none

sfdisk -q whole.img <<END
label: dos
label-id: 0x11223344

1: start=$bootskip, size=$bootsize, type=ef, bootable
2: start=$rootskip, size=$rootsize, type=83
END

dd of=whole.img if=bootfs.img bs=512 seek=$bootskip conv=notrunc status=none
dd of=whole.img if=rootfs.img bs=512 seek=$rootskip conv=notrunc status=none
