all: whole.img

../minibase/out:
	@echo minibase has not been built
	@false

whole.img: rootfs.img bootfs.img ../common/whole.map
	./whole.sh

bootfs.img: initrd.img ../common/whole.map
	./bootfs.sh

rootfs.img: ../common/whole.map | ../minibase/out
	./rootfs.sh

initrd.img: | ../minibase/out
	./initrd.sh

clean:
	rm -fr rootfs/ bootfs/ initrd/
	rm -f rootfs.img bootfs.img initrd.img whole.img
