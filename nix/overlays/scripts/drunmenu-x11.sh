#!/usr/bin/env bash

set -euo pipefail

program="$(
	rofi \
		-cache-dir "''${XDG_CACHE_HOME:-$HOME/.cache}/rofi/drunmenu" \
		-run-command "echo {cmd}" \
		-show drun
)"

# shellcheck disable=SC2086
exec spawn $program
