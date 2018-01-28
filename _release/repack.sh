#!/bin/sh

rm -fr sys-1-plain
rm -fr sys-2-crypt
rm -fr prebuilt

rm -f prebuilt.tar.xz
rm -f sys-1-plain.tar.xz
rm -f sys-2-crypt.tar

mkdir sys-2-crypt
cp -at sys-2-crypt ../sys-2-crypt/whole.img 
cp -at sys-2-crypt ../sys-2-crypt/xqemu.sh
cp -at sys-2-crypt ../USAGE

mkdir sys-1-plain
cp -at sys-1-plain ../sys-1-plain/whole.img 
cp -at sys-1-plain ../sys-1-plain/xqemu.sh
cp -at sys-1-plain ../USAGE

mkdir prebuilt
git --git-dir ../.git archive HEAD | tar -x -C prebuilt --exclude _release
git --git-dir ../.git/modules/minibase archive HEAD | tar -x -C prebuilt/minibase
cp -at prebuilt ../brrootfs

tar -Jcvf sys-1-plain.tar.xz sys-1-plain
tar -cvf sys-2-crypt.tar sys-2-crypt
tar -Jcvf prebuilt.tar.xz prebuilt
