all: whole.img

whole.img: rootfs.img bootfs.img whole.map
	./whole.sh

bootfs.img: initrd.img whole.map
	./bootfs.sh

rootfs.img: whole.map
	./rootfs.sh

initrd.img:
	./initrd.sh

clean:
	rm -fr rootfs/ bootfs/ initrd/
	rm -f rootfs.img bootfs.img initrd.img whole.img
