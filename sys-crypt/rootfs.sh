#!/bin/sh

source ./whole.map

../common/rootfs.sh $rootsize

echo "Encrypting root filesystem"
../minibase/out/sbin/deitool rootfs.img rootfs.enc dekeys.nkw
