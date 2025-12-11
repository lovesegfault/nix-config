# agenix-rekey configuration for automatic secret rekeying
{
  config,
  flake,
  lib,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.agenix-rekey.nixosModules.default
  ];

  age.rekey = {
    # Master identity - private key used for decryption (must exist on machine running rekey)
    masterIdentities = [ "/home/bemeurer/.ssh/bemeurer" ];

    # Store rekeyed secrets locally per-host
    storageMode = "local";
    localStorageDir = lib.mkDefault (self + "/secrets/rekeyed/${config.networking.hostName}");

    # Host pubkey must be set per-host in configurations/nixos/<host>/default.nix:
    # age.rekey.hostPubkey = "ssh-ed25519 AAAA...";
  };
}
