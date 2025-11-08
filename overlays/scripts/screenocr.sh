#!/usr/bin/env bash

set -euo pipefail

grim -t png -g "$(slurp)" - |
	tesseract stdin stdout -l "eng+equ" |
	tr -d '\f' |
	wl-copy
