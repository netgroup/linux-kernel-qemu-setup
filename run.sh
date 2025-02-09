#!/bin/bash

readonly KERNIMG=bzImage
readonly ROOTFS=bookworm.img

if [ ! -f "${KERNIMG}" ]; then
	echo "error: missing kernel image, e.g., bzImage"
	exit 1
fi

if [ ! -f "${ROOTFS}" ]; then
	echo "error: missing virtual disk"
	exit 1
fi

qemu-system-x86_64 \
        --enable-kvm \
	-cpu host \
        -smp 4,sockets=1,cores=4,threads=1 \
	-m 4G \
        -kernel "${KERNIMG}" \
        -drive file="${ROOTFS}",format=raw \
        -append "root=/dev/sda rw console=ttyS0 trace_clock=local" \
	-netdev user,host=10.0.2.10,id=mynet0,hostfwd=tcp::10022-:22 \
	-device virtio-net-pci,netdev=mynet0 \
	-virtfs local,path=shared,mount_tag=shared,security_model=mapped-xattr \
        --nographic \
	-pidfile vm.pid

# NOTE: to setup ad debugger add the '-s -S' in the command line above.
