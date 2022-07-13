{ self
, darwin
, home-manager
, nixpkgs
, templates
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).nix-darwin.all;

  nixRegistry = {
    nix.registry = {
      templates.flake = templates;
      nixpkgs.flake = nixpkgs;
    };
  };

  genConfiguration = hostname: { localSystem, ... }:
    darwin.lib.darwinSystem {
      system = localSystem;
      pkgs = self.pkgs.${localSystem};
      modules = [
        (../hosts + "/${hostname}")
        nixRegistry
        home-manager.darwinModules.home-manager
      ];
    };
in
lib.mapAttrs genConfiguration hosts
