#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2046
nix-store -q --size $(nix-store -qR "$(readlink -e "$1")") |
	gawk '{ a+=$1 } END { print a }' |
	numfmt --to=iec-i
