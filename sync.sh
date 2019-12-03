#! /usr/bin/env bash
set -o pipefail -o noclobber -o nounset

SYSTEM_SYNC=0
HOME_SYNC=0

NIXOS_BOOT=0
NIXOS_BUILD=0
NIXOS_SWITCH=1

HOME_BUILD=0
HOME_SWITCH=1

UPGRADE=0

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
        rsync -irhlt "$script_dir/" "$user_src_path/" ||
            error "Failed to copy $repo_name"
        fix_perms "$USER" "$user_src_path"
    fi

    if ! [ -d "$home_manager_path" ]; then
        warn "User $USER has no ~/.config/nixpkgs, creating"
        mkdir -p "$home_manager_path"
        ln -s "$user_src_path/home" "$home_manager_path/home" ||
            error "Failed to symlink $user_src_path/home to $home_manager_path/home"
        ln -s "$user_src_path/share" "$home_manager_path/share" ||
            error "Failed to symlink $user_src_path/share to $home_manager_path/share"
    fi

    if ! [ -f "$home_manager_path/config.nix" ]; then
        warn "User $USER has no $home_manager_path/config.nix, creating"
        cp "$user_src_path/misc/config.nix" "$home_manager_path"
    fi

    if ! [ -f "$home_manager_path/home.nix" ]; then
        warn "User $USER has no $home_manager_path/home.nix, you MUST create it."
        warn "See $user_src_path/misc/home.nix"
    fi

    if ! [ -L "$home_manager_path/home" ]; then
        warn "$home_manager_path/home is not a symlink while it should be"
    fi

    if ! [ -L "$share_manager_path/share" ]; then
        warn "$share_manager_path/share is not a symlink while it should be"
    fi
}

function check_sudo() {
    [ -x "$(command -v sudo)" ] || error "Sudo not available."
    [[ "$USER" == *"not allowed to run sudo"* ]] &&
        error "$USER does not have sudo privileges"
}

function rebuild_system() {
    local op=""
    local arg=""
    if [ $NIXOS_SWITCH = 1 ]; then
        op="switch"
    elif [ $NIXOS_BOOT = 1 ]; then
        op="boot"
    elif [ $NIXOS_BUILD = 1 ]; then
        op="build"
    else
        error "Neither build,boot,nor switch passed to NixOS?"
    fi
    [ $UPGRADE == 1 ] && arg="--upgrade"
    sudo nixos-rebuild "$op" $arg
}

function rebuild_home() {
    local op
    if [ $HOME_SWITCH = 1 ]; then
        op="switch"
    elif [ $HOME_BUILD = 1 ]; then
        op="build"
    else
        error "Neither build,nor switch passed to home-manager?"
    fi
    [ $UPGRADE == 1 ] && nix-channel --update
    home-manager "$op"
}

function check_getopt() {
    ! getopt --test > /dev/null
    if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
        error '`getopt --test` failed in this environment.'
    fi
}

function parse_opts() {
    local options="sbtuyha"
    local longopts="switch,build,boot,upgrade,system,home,all"
    local parsed
    ! parsed=$(getopt --options="$options" --longoptions="$longopts" --name "$0" -- "$@")
    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        error "Wrong arguments passed"
    fi
    eval set -- "$parsed"
    while true; do
        case "$1" in
            -s|--switch)
                NIXOS_SWITCH=1
                NIXOS_BOOT=0
                NIXOS_BUILD=0
                HOME_SWITCH=1
                HOME_BUILD=0
                shift
                ;;
            -b|--build)
                NIXOS_SWITCH=0
                NIXOS_BOOT=0
                NIXOS_BUILD=1
                HOME_SWITCH=0
                HOME_BUILD=1
                shift
                ;;
            -t|--boot)
                NIXOS_SWITCH=0
                NIXOS_BOOT=1
                NIXOS_BUILD=0
                HOME_SWITCH=1
                HOME_BUILD=0
                shift
                ;;
            -u|--upgrade)
                UPGRADE=1
                shift
                ;;
            -y|--system)
                SYSTEM_SYNC=1
                shift
                ;;
            -h|--home)
                HOME_SYNC=1
                shift
                ;;
            -a|--all)
                SYSTEM_SYNC=1
                HOME_SYNC=1
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                error "Invalid argument"
                ;;
        esac
    done
}

function main() {
    [ "$(id -u)" != 0 ] || error "Run this as a your user, not root."
    check_getopt
    parse_opts "$@"
    if [ $SYSTEM_SYNC = 1 ]; then
        check_sudo
        sync_system
        check_system
        rebuild_system
        ok "System OK"
    fi
    if [ $HOME_SYNC == 1 ]; then
        check_home
        rebuild_home
        ok "Home OK"
    fi
}

main "$@"
