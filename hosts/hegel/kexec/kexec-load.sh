#!/usr/bin/env bash

set -e
# adapted from https://github.com/flowztul/keyexec/blob/9af064a6aa4d92cc42d062398bc80754a9a6edd8/etc/default/kexec-cryptroot
# Copyright 2017, Lutz Wolf flow@0x0badc0.de
# Licensed under GPLv2 or later.

# Generate temporary initrd.img with LUKS master keys for kexec reboot

umask 0077

CRYPTROOT_TMPDIR="$(mktemp -d --tmpdir=/dev/shm initrd.XXXXXXXXXX)"

# clear the folder when exiting
cleanup() {
	shred -fu "${CRYPTROOT_TMPDIR}/initrd.img" || true
	shred -fu "${CRYPTROOT_TMPDIR}/boot/crypto_keyfile.bin" || true
	rm -rf "${CRYPTROOT_TMPDIR}"
}

trap cleanup INT TERM EXIT

p=$(readlink -f /nix/var/nix/profiles/system)
if ! [[ -d $p ]]; then
	echo "Could not find system profile for prepare-kexec"
	exit 1
fi

# prepare the boot folder
mkdir "${CRYPTROOT_TMPDIR}/boot"
cp /boot/crypto_keyfile.bin "${CRYPTROOT_TMPDIR}/boot/"

# append the boot folder to the initrd
cp "$p/initrd" "${CRYPTROOT_TMPDIR}/initrd.img"
cd "${CRYPTROOT_TMPDIR}"
find boot | cpio -H newc -o | gzip >>"${CRYPTROOT_TMPDIR}/initrd.img"

# load the new initrd (exec is needed)
exec kexec --load "$p/kernel" --initrd="${CRYPTROOT_TMPDIR}/initrd.img" --append="$(cat "$p/kernel-params") init=$p/init"
