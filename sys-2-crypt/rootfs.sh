#!/bin/sh

set -e

plain=../sys-1-plain

if [ ! -f $plain/rootfs.img ]; then
	echo "Assembling plain rootfs"
	(cd $plain && ./rootfs.sh)
fi

if [ ! -f dekeys.nkw ]; then
	../minibase/out/bin/dektool create dekeys.nkw
fi

echo "Encrypting root filesystem"
../minibase/out/bin/deitool $plain/rootfs.img rootfs.img dekeys.nkw
