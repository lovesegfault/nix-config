#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit 1
fi

# Get locations
hostname="$(hostname)"
nixos_config_dir="/etc/nixos"
git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
system_dir="${git_dir}/system/${hostname}"

# Check that we have configurations for this system in the tree
if [ ! -d "${system_dir}" ] || [ ! -f "${system_dir}/configuration.nix" ]; then
    echo "No configuration.nix found. Please place them under ${system_dir}."
    exit 1
fi

# Prompt user about viewing file diffs
read -p "Do you want to see a diff of the files being changed?  [Y/N] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Iterate over files and show diffs
    for config in "${system_dir}/"*; do
        f_name="${config##*/}"
        if [ -f "${nixos_config_dir}/${f_name}" ]; then
            diff -y --color=always -- "${nixos_config_dir}/${f_name}" "${config}" | less -cR
        else
            echo "New file ${f_name}"
        fi
    done
fi

# Prompt user for confirmation
read -p "Are you sure you want to overwrite your current system configurations? [Y/N] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # Give up
    echo "No files were altered."
    exit 0
fi

# Backup existing files to /tmp & delete originals
for config in "${nixos_config_dir}/"*; do
    [ -e ${config} ] || continue
    f_name="${config##*/}"
    mv -f "${config}" "/tmp/${f_name}.bak"
done

# Copy files
cp -d "${system_dir}/"* "${nixos_config_dir}/"

# Success
echo "Updated system configuration files. Please verify them before usage."
