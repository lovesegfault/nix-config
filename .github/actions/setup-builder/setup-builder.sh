#!/usr/bin/env bash

set -euo pipefail

SSH_CONFIG="/root/.ssh"
sudo mkdir -p "$SSH_CONFIG"

KEY_PATH="$(sudo mktemp -p "$SSH_CONFIG" 'XXXXXXXX.key')"
echo "$SSH_KEY" | sudo tee "$KEY_PATH" > /dev/null
sudo chmod 0600 "$KEY_PATH"

echo "$KNOWN_HOST" | sudo tee -a "${SSH_CONFIG}/known_hosts" > /dev/null

NIX_CFG=(
    "builders-use-substitutes = true"
)

BUILDER_CFG=(
    "${USERNAME}@${HOSTNAME}"
    "$SYSTEM"
    "$KEY_PATH"
    "$CORES"
    "$SPEED_FACTOR"
    "$FEATURES"
)

echo "${BUILDER_CFG[*]} -" | sudo tee -a /etc/nix/machines > /dev/null
echo "${NIX_CFG[*]}" | sudo tee -a /etc/nix/nix.conf > /dev/null

cat /etc/nix/machines

nix_path="$(realpath $(which nix))"
sudo "$nix_path" store ping --store "ssh://${USERNAME}@${HOSTNAME}"
