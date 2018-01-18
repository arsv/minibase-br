#!/bin/sh

set -e

source ./whole.map

dd of=whole.img if=/dev/zero bs=512 count=$totalsize status=none

sfdisk -q --no-reread whole.img <<END
label: dos
label-id: 0x11223344

1: start=$bootskip, size=$bootsize, type=ef, bootable
2: start=$rootskip, size=$rootsize, type=83
END
