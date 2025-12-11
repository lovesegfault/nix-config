#!/usr/bin/env bash

set -euo pipefail

sort <<<"$(find "$1" -mindepth 2 -type d -print0 | while read -r -d $'\0' album; do [ -f "$album/cover.jpg" ] || echo "$album"; done)"
