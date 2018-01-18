#!/bin/sh

set -e

plain=../sys-1-plain

if [ ! -f $plain/rootfs.img ]; then
	echo "Assembling plain rootfs"
	(cd $plain && ./rootfs.sh)
fi

if [ ! -f dekeys.nkw ]; then
	../minibase/out/sbin/dektool create dekeys.nkw
fi

echo "Encrypting root filesystem"
../minibase/out/sbin/deitool $plain/rootfs.img rootfs.img dekeys.nkw
