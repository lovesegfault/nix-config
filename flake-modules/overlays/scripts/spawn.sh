#!/usr/bin/env bash

set -euo pipefail

[ "$#" -ge 1 ] || exit 1
pname="$(basename "$1")"
uuid="$(uuidgen)"
exec systemd-run --user --scope --unit "spawn-$pname-$uuid" "$@"
