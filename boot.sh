#! /usr/bin/env bash
set -o pipefail -o noclobber -o nounset -o errexit
function boot() {
    [ "$#" -eq 1 ] || exit 1
    local systemPath="$1"
    local switch="$systemPath/bin/switch-to-configuration"
    sudo nix-env --set \
        --profile "/nix/var/nix/profiles/system" \
        "$systemPath"
    sudo "$switch" "boot" ||
        echo "Failed to activate system"
}

systemPath="$(realpath "$1")"
echo "booting ${systemPath}"
boot "${systemPath}"
