#!/bin/sh

exec qemu-system-x86_64 -enable-kvm -hda whole.img
