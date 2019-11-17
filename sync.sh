#! /usr/bin/env bash

function cprint() {
    if [ "$#" -lt 2 ]; then
        printf "Broken usage of cprint\n"
        exit 1
    fi
    local color="$1"
    local msg="${@:2}"
    local reset="$(tput sgr0)"
    printf "${color}${msg}${reset}\n"
}

function warn() {
    local yellow="$(tput setaf 3)"
    cprint "$yellow" "$@"
}

function ok() {
    local green="$(tput setaf 2)"
    cprint "$green" "$@"
}

sudo cp -r ./system/* /etc/nixos/

[ -f /etc/nixos/configuration.nix ] \
    || warn "No /etc/nixos/configuration.nix present!"
[ -f /etc/nixos/hardware-configuration.nix ] \
    || warn "No/etc/nixos/hardware-configuration.nix present!"

ok "Syncd"
