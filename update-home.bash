#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# cp -df
home_manager_dir="${HOME}/.config/nixpkgs"
git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Copy files, overwriting & preserving symlinks
cp -df "${home_manager_dir}/"* "${git_dir}/home/"
