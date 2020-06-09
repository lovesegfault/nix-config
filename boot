#! /usr/bin/env bash
set -o pipefail -o noclobber -o nounset
function boot() {
    [ "$#" -eq 1 ] || exit 1
    local systemPath="$1"
    local switch="$systemPath/bin/switch-to-configuration"
    sudo nix-env --set \
        --profile "/nix/var/nix/profiles/system" \
        "$systemPath"
    sudo "$switch" "boot" ||
        error "Failed to activate system"
}

systemPath="$1"
echo "booting ${systemPath}"
boot "${systemPath}"
