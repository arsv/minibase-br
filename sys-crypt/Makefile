all: whole.img

dekeys.nkw:
	../minibase/out/sbin/dektool -c dekeys.nkw

whole.img: rootfs.img bootfs.img whole.map
	./whole.sh

bootfs.img: initrd.img whole.map
	./bootfs.sh

rootfs.img: whole.map dekeys.nkw
	./rootfs.sh

initrd.img: dekeys.nkw
	./initrd.sh

clean:
	rm -fr rootfs/ bootfs/ initrd/
	rm -f rootfs.img rootfs.enc bootfs.img initrd.img whole.img

distclean: clean
	rm -f dekeys.nkw
