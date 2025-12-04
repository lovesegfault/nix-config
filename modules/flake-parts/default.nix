# Flake-parts module aggregator
# Note: These must be path imports because self.flakeModules isn't available
# during flake module evaluation (would cause infinite recursion)
{ inputs, ... }:
{
  imports = [
    # nixos-unified's flake module (provides activate, update packages)
    inputs.nixos-unified.flakeModules.default

    # Our modules
    ./actions.nix
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
