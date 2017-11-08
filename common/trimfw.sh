#1/bin/sh

cd rootfs/lib/firmware

last=''
for i in `ls -vr | grep '\.ucode$'`; do
	stem=`echo "$i" | sed -e 's/-[^-]*\.ucode$//'`;

	if [ "$stem" = "$last" ]; then
		rm $i
	else
		last="$stem"
	fi
done
