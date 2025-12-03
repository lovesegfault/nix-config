# Shared nix registry configuration
# Works for NixOS, Darwin, and home-manager (all have nix.registry option)
{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };
}
