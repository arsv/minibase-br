all: kernel.img initrd.img whole.img

whole.img:
	./whole.sh

kernel.img:
	./kernel.sh

initrd.img:
	./initrd.sh

clean:
	rm -fr initrd/
	rm -f initrd.img kernel.img whole.img
