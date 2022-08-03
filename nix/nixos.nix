{ self
, home-manager
, impermanence
, nixos-hardware
, nixpkgs
, ragenix
, templates
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).nixos.all;

  netHostMap = {
    networking.hosts = lib.mapAttrs' (n: v: lib.nameValuePair v.address [ n ]) hosts;
  };

  nixRegistry = {
    nix.registry = {
      nixpkgs.flake = nixpkgs;
      p.flake = nixpkgs;
      pkgs.flake = nixpkgs;
      templates.flake = templates;
    };
  };

  genConfiguration = hostname: { localSystem, ... }:
    lib.nixosSystem {
      system = localSystem;
      pkgs = self.pkgs.${localSystem};
      modules = [
        (../hosts + "/${hostname}")
        nixRegistry
        netHostMap
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        ragenix.nixosModules.age
      ];
      specialArgs = {
        impermanence = impermanence.nixosModules;
        nixos-hardware = nixos-hardware.nixosModules;
      };
    };
in
lib.mapAttrs genConfiguration hosts
