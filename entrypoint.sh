#!/bin/bash

imagepath="images/${1}"
arch="${2}"
sizeincrease="${3}"

if [ ! -f "${imagepath}" ]; then
    echo "Image file does not exists: ${1}"
    exit -1
fi

if [ ! -z "${sizeincrease}" ]; then
    qemu-img resize -f raw "${imagepath}" "+${sizeincrease}"
fi

# @TBD: If almost full, lets make the image a bit bigger

# Run kpartx to create mount points
kpartx -a "${imagepath}"

# Resize fs
echo "Resizing filesystem to fill entire card"
parted -s /dev/loop0 "resizepart 2 -1" quit
e2fsck -fy /dev/mapper/loop0p2
resize2fs /dev/mapper/loop0p2

# Mount partitions
echo "Set up sdcard partitions"

mount -o rw /dev/mapper/loop0p2 mnt
mount -o rw /dev/mapper/loop0p1 mnt/boot/firmware

# Mount binds
echo "Set up system binds"
mount --bind /sys mnt/sys
mount --bind /proc mnt/proc
mount --bind /dev/pts mnt/dev/pts

# Copy qemu binary
cp "/usr/bin/qemu-${arch}-static" mnt/usr/bin

# Transfer to shell
echo "Transferring to image chroot bash, enter exit if you are done."
chroot mnt /bin/bash -i
# systemd-nspawn -D mnt /bin/bash

# Clean up
echo "Cleaning up"
umount mnt/{dev/pts,sys,proc,boot/firmware,}
kpartx -d "${imagepath}"
losetup -D
dmsetup remove_all
losetup

exit 0