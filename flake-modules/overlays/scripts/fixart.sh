#!/usr/bin/env bash

set -euo pipefail

function ctrl_c() {
	exit 1
}
trap ctrl_c INT

function die() {
	echo "$@"
	exit 1
}

newart=$1
[ $# -gt 1 ] || die "Invalid usage"

beet clearart "${@:2}"
beet embedart -f "$newart" "${@:2}"
beet extractart -a "${@:2}"

outpath="$(beet ls -a -p "${@:2}")"

original="$(sha256sum "$newart" | cut -f 1 -d " ")"
updated="$(sha256sum "$outpath/cover.jpg" | cut -f 1 -d " ")"
[ "$original" == "$updated" ] || exit 1
echo "OK: SHA"

jpgs="$(find "$outpath" -type f -name "*.jpg" | wc -l)"
[ "$jpgs" -eq 1 ] || die "Too many .jpg in album path"
lingering="$(find "$outpath" -type f -iname "cover.*" -not -iname "cover.jpg")"
[ -z "$lingering" ] || die "Lingering cover files: $lingering"
echo "OK: cover count"
