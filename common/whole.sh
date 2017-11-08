#!/bin/sh

set -e
top=..
out="$1"
ext="$2"

if [ -f "NOT-HERE" ]; then
	echo "$0: cannot run in this directory" >&2
	exit 2
elif [ -z "$totalsize" ]; then
	echo "$0: whole.map not sourced" >&2
	exit 2
fi

if [ -z "$out" ]; then
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
dd of=$out if=rootfs$ext bs=512 seek=$rootskip conv=notrunc
