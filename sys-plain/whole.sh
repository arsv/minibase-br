#!/bin/sh

set -e

source ./whole.map

dd of=whole.img if=/dev/zero bs=512 count=$totalsize

dd of=whole.img if=/usr/lib/syslinux/bios/mbr.bin conv=notrunc

sfdisk whole.img <<END
label: dos
label-id: 0x11223344

1: start=$bootskip, size=$bootsize, type=ef, bootable
2: start=$rootskip, size=$rootsize, type=83
END

dd of=whole.img if=bootfs.img bs=512 seek=$bootskip conv=notrunc
dd of=whole.img if=rootfs.img bs=512 seek=$rootskip conv=notrunc
