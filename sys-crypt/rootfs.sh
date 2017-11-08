#!/bin/sh

source ./whole.map

../common/rootfs.sh $rootsize

echo "Encrypting root filesystem"
../minibase/out/sbin/deitool -e rootfs.img rootfs.enc dekeys.nkw 1
