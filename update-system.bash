#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit 1
fi

read -p "Are you sure? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Get locations
    hostname="$(hostname)"
    nixos_config_dir="/etc/nixos"
    git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    system_dir="${git_dir}/system/${hostname}"

    # Check that we have configurations for this system in the tree
    if [ ! -d "$system_dir" ]; then
        echo "No configurations found. Please place them under ${system_dir}."
        exit 1
    fi

    # Copy files, overwriting & preserving symlinks
    cp -df "${system_dir}"* "${nixos_config_dir}/"
else
    # Give up
    echo "No files were altered."
    exit 0
fi

# Success
echo "Updated system configuration files. Please verify them before usage."
