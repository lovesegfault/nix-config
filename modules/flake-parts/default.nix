# Flake-parts module aggregator
{ ... }:
{
  imports = [
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
