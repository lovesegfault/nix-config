# Shared nixpkgs configuration
# Works for NixOS, Darwin, and home-manager (all have nixpkgs.config option)
{ flake, ... }:
let
  inherit (flake) self;
in
{
  nixpkgs = {
    overlays = [ self.overlays.default ];
    config.allowUnfree = true;
  };
}
