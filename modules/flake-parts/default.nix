# Flake-parts module aggregator
{ ... }:
{
  imports = [
    ./configurations.nix
    ./dev-shell.nix
    ./modules.nix
    ./overlays.nix
    ./packages.nix
    ./pre-commit.nix
    ./treefmt.nix
  ];
}
