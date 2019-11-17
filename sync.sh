#! /usr/bin/env bash

function cprint() {
    if [ "$#" -lt 2 ]; then
        printf "Broken usage of cprint\n"
        exit 1
    fi
    local color="$1"
    local msg="${*:2}"
    local reset
    reset="$(tput sgr0)"

    [ -z ${NO_COLOR+1} ] || color=""
    [ -z ${NO_COLOR+1} ] || reset=""

    printf "%s%s%s\n" "$color" "$msg" "$reset"
}

function error() {
    local red
    red="$(tput setaf 1)"
    cprint "$red" "$@"
    exit 1
}

function warn() {
    local yellow
    yellow="$(tput setaf 3)"
    cprint "$yellow" "$@"
}

function ok() {
    local green
    green="$(tput setaf 2)"
    cprint "$green" "$@"
}

function fix_perms() {
    [ "$#" -eq 2 ] || error "fix_perms USER PATH"
    local user="$1"
    local path="$2"

    local fix_dirs="find \"$path\" -type d -exec chmod 0755 {} \;"
    local fix_files="find \"$path\" -type f -exec chmod 0644 {} \;"

    sudo runuser -l "$user" -c "${fix_dirs}"
    sudo runuser -l "$user" -c "${fix_files}"
}

function sync_system() {
    sudo rsync -irhlt --delete ./system/combo/ /etc/nixos/combo/
    sudo rsync -irhlt --delete ./system/modules/ /etc/nixos/modules/
    sudo rsync -irhlt --delete ./system/machines/ /etc/nixos/machines/
    fix_perms "root" /etc/nixos
}

function check_system() {
    [ -f /etc/nixos/configuration.nix ] ||
        warn "No /etc/nixos/configuration.nix present!"
    [ -f /etc/nixos/hardware-configuration.nix ] ||
        warn "No/etc/nixos/hardware-configuration.nix present!"
}

function check_home() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
    local repo_name
    repo_name="$(basename "$script_dir")"
    local home_manager_path="$HOME/.config/nixpkgs"
    local user_src_path="$HOME/src/$repo_name"

    if ! [ -d "$user_src_path" ]; then
        warn "User has no ~/src/$repo_name, creating"
        mkdir -p "$HOME/src"
        rsync -irhlt "$script_dir" "$user_src_path" ||
            error "Failed to copy $repo_name"
        fix_perms "$USER" "$user_src_path"
    fi

    if ! [ -d "$home_manager_path" ]; then
        warn "User $USER has no ~/.config/nixpkgs, symlinking"
        ln -s "$user_src_path" "$home_manager_path" ||
            error "Failed to symlink $user_src_path to $home_manager_path"
    fi

    if ! [ -L "$home_manager_path" ]; then
        warn "$home_manager_path is not a symlink while it should be"
    fi
}

function check_sudo() {
    [ -x "$(command -v sudo)" ] || error "Sudo not available."
    [[ "$USER" == *"not allowed to run sudo"* ]] &&
        error "$USER does not have sudo privileges"
}

function main() {
    [ "$#" -eq 0 ] || error "This program takes no arguments."
    [ "$(id -u)" != 0 ] || error "Run this as a your user, not root."
    check_sudo
    sync_system
    check_system
    ok "System OK"
    check_home
    ok "Home OK"
}

main "$@"
