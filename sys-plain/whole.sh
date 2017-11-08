#!/bin/sh

set -e

source ./whole.map

if [ -n "$1" ]; then
	out="$1"
else
	out="whole.img"
	dd of=$out if=/dev/zero bs=512 count=$totalsize
fi

dd of=$out if=/usr/lib/syslinux/bios/mbr.bin conv=notrunc

sfdisk -q $out <<END
label: dos
label-id: 0x11223344

1: start=$bootskip, size=$bootsize, type=ef, bootable
2: start=$rootskip, size=$rootsize, type=83
END

dd of=$out if=bootfs.img bs=512 seek=$bootskip conv=notrunc
dd of=$out if=rootfs.img bs=512 seek=$rootskip conv=notrunc
