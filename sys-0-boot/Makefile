all: kernel.bin initrd.img whole.img

kernel.bin:
	./kernel.sh

initrd.img:
	./initrd.sh

whole.img:
	./whole.sh

clean:
	rm -fr initrd/
	rm -f initrd.img kernel.bin whole.img
