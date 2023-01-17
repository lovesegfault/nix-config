#!/usr/bin/env/bash

set -euo pipefail

# XXX: We patch-in the emoji-list path in Nix
# shellcheck disable=SC2154
emoji="$(
	wofi \
		--cache-file="$XDG_CACHE_HOME/wofi/emojimenu" \
		-d "allow_markup=false" \
		-p emoji \
		--show dmenu <"${emoji_list}" | cut -f1 -d" "
)"

wl-copy --trim-newline <<<"$emoji"
