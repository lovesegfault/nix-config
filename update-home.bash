#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Check if root
if [ "$EUID" -eq 0 ]
  then echo "Please run this as a normal user."
  exit 1
fi

# Get locations
home_manager_dir="${HOME}/.config/nixpkgs"
git_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
home_dir="${git_dir}/home"

# Check that we have configuration files
if [ ! -d "${home_dir}" ] || [ ! -f "${home_dir}/home.nix" ]; then
    echo "No home.nix found. Please place it under ${home_dir}."
    exit 1
fi

# Prompt user about viewing file diffs
read -p "Do you want to see a diff of the files being changed?  [Y/N] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Iterate over files and show diffs
    for config in "${home_dir}/"*; do
        f_name="${config##*/}"
        if [ -f "${home_manager_dir}/${f_name}" ]; then
            diff -y --color=always -- "${home_manager_dir}/${f_name}" "${config}" | less -cR
        else
            echo "New file ${f_name}"
        fi
    done
fi

# Prompt user for confirmation
read -p "Are you sure you want to overwrite your current home configurations? [Y/N] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # Give up
    echo "No files were altered."
    exit 0
fi

# Backup existing files to /tmp & delete originals
for config in "${home_manager_dir}/"*; do
    [ -e ${config} ] || continue
    f_name="${config##*/}"
    mv -f "${config}" "/tmp/${f_name}.bak"
done

# Copy files
cp -d "${home_dir}/"* "${home_manager_dir}/"

# Success
echo "Updated home configuration files. Please verify them before usage."
