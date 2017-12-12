all: whole.img

../minibase/out:
	@echo minibase has not been built
	@false

dekeys.nkw:
	../minibase/out/sbin/dektool create dekeys.nkw

whole.img: rootfs.img bootfs.img whole.map
	./whole.sh

bootfs.img: initrd.img whole.map
	./bootfs.sh

rootfs.img: whole.map dekeys.nkw | ../minibase/out
	./rootfs.sh

initrd.img: dekeys.nkw | ../minibase/out
	./initrd.sh

clean:
	rm -fr rootfs/ bootfs/ initrd/
	rm -f rootfs.img rootfs.enc bootfs.img initrd.img whole.img

distclean: clean
	rm -f dekeys.nkw
