#!/usr/bin/env/bash

set -euo pipefail

# XXX: We patch-in the emoji-list path in Nix
# shellcheck disable=SC2154
emoji="$(
	rofi \
		-cache-dir "$XDG_CACHE_HOME/rofi/emojimenu" \
		-p emoji \
		-dmenu <"${emoji_list}" | cut -f1 -d" "
)"

xclip -in -rmlastnl -selection clipboard <<<"$emoji"
