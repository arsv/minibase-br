all: whole.img

initrd.img:
	./initrd.sh

bootfs.img: initrd.img whole.map
	./bootfs.sh

rootfs.img: whole.map
	./rootfs.sh

whole.img: rootfs.img bootfs.img whole.map
	./whole.sh

clean:
	rm -fr rootfs/ bootfs/ initrd/
	rm -f rootfs.img bootfs.img initrd.img whole.img
