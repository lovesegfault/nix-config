# Explicit configuration wiring for nixos-unified
# This module defines all NixOS, Darwin, and home-manager configurations
{
  inputs,
  self,
  withSystem,
  ...
}:
let
  # Helper to create a NixOS system
  mkNixosSystem =
    hostname: hostPlatform:
    withSystem hostPlatform (
      { pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [ (self + "/configurations/nixos/${hostname}") ];
        specialArgs = {
          flake = { inherit inputs self; };
        };
      }
    );

  # Helper to create a Darwin system
  mkDarwinSystem =
    hostname: hostPlatform:
    withSystem hostPlatform (
      { pkgs, system, ... }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit pkgs system;
        modules = [ (self + "/configurations/darwin/${hostname}") ];
        specialArgs = {
          flake = { inherit inputs self; };
        };
      }
    );

  # Helper to create a home-manager configuration
  mkHomeConfig =
    hostname: hostPlatform:
    withSystem hostPlatform (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (self + "/configurations/home/${hostname}") ];
        extraSpecialArgs = {
          flake = { inherit inputs self; };
        };
      }
    );
in
{
  flake = {
    nixosConfigurations = {
      comte = mkNixosSystem "comte" "x86_64-linux";
      hegel = mkNixosSystem "hegel" "x86_64-linux";
      jung = mkNixosSystem "jung" "x86_64-linux";
      plato = mkNixosSystem "plato" "x86_64-linux";
      spinoza = mkNixosSystem "spinoza" "x86_64-linux";
    };

    darwinConfigurations = {
      poincare = mkDarwinSystem "poincare" "aarch64-darwin";
    };

    homeConfigurations = {
      goethe = mkHomeConfig "goethe" "x86_64-linux";
      hilbert = mkHomeConfig "hilbert" "x86_64-linux";
      popper = mkHomeConfig "popper" "x86_64-linux";
    };
  };
}
