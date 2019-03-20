#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# cp -df
hostname="$(hostname)"
nixos_config_dir="/etc/nixos"
git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Copy files, overwriting & preserving symlinks
cp -df "${nixos_config_dir}/"* "${git_dir}/system/${hostname}/"
