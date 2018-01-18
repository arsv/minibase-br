#!/bin/sh

exec qemu-system-x86_64 -enable-kvm -drive format=raw,file=whole.img \
	-chardev vc,id=ttyS0 \
	-chardev stdio,id=ttyS1 \
	-serial chardev:ttyS0 \
	-serial chardev:ttyS1
