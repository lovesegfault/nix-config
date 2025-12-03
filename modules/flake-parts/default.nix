# Flake-parts module aggregator
{ inputs, ... }:
{
  imports = [
    # nixos-unified's flake module (provides activate, update packages)
    inputs.nixos-unified.flakeModules.default

    # Our modules
    ./agenix-rekey.nix
    ./configurations.nix
    ./dev-shell.nix
    ./modules.nix
    ./overlays.nix
    ./packages.nix
    ./pre-commit.nix
    ./treefmt.nix
  ];
}
