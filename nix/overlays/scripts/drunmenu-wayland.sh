#!/usr/bin/env bash

set -euo pipefail

program="$(
	wofi \
		--allow-images \
		--allow-markup \
		--insensitive \
		--define "drun-print_command=true" \
		--term=foot \
		--cache-file="''${XDG_CACHE_HOME:-$HOME/.cache}/wofi/drunmenu" \
		--show=drun |
		sed "s/%[a-zA-Z]//g"
)"

# shellcheck disable=SC2086
exec spawn $program
