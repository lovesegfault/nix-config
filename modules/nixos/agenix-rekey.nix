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
    # Master identity - private key used for decryption (must exist on machine running rekey).
    # agenix-rekey splices the identity into its scripts verbatim, so $HOME
    # expands at run time and the same path works from Linux (/home) and macOS
    # (/Users). The quotes are part of the value because those scripts go
    # through shellcheck, and giving the pubkey keeps the identity out of the
    # one spot where a quoted value doesn't pass.
    masterIdentities = [
      {
        identity = ''"$HOME/.ssh/bemeurer"'';
        pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";
      }
    ];

    # Store rekeyed secrets locally per-host
    storageMode = "local";
    localStorageDir = lib.mkDefault (self + "/secrets/rekeyed/${config.networking.hostName}");

    # Host pubkey must be set per-host in configurations/nixos/<host>/default.nix:
    # age.rekey.hostPubkey = "ssh-ed25519 AAAA...";
  };
}
