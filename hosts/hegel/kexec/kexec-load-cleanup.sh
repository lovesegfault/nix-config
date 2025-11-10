#!/usr/bin/env bash

PREFIX="/dev/shm/initrd."

for dir in "${PREFIX}"*/; do
	shred -fu "${dir}/initrd.img" || true
	shred -fu "${dir}/boot/crypto_keyfile.bin" || true
	rm -rf "${dir}"
done
