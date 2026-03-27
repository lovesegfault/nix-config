# NixOS modules aggregator
# This is the main entry point for NixOS configurations
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules (shared across all NixOS hosts)
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index
    inputs.stylix.nixosModules.stylix

  ]
  ++ (with self.nixosModules; [
    agenix-rekey
    core
    home-manager-integration
    tailscale-address
  ]);
}
