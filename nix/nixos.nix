{ self
, home-manager
, impermanence
, nixpkgs
, ragenix
, templates
, ...
}@inputs:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).nixosHosts;

  netHostMap = {
    networking.hosts = lib.mapAttrs' (n: v: lib.nameValuePair v.address [ n ]) hosts;
  };

  nixRegistry = {
    nix.registry = {
      templates.flake = templates;
      nixpkgs.flake = nixpkgs;
    };
  };

  hostPkgs = localSystem: {
    nixpkgs = {
      localSystem.system = localSystem;
      pkgs = self.nixpkgs.${localSystem};
    };
  };

  genConfiguration = hostname: { localSystem, ... }:
    lib.nixosSystem {
      modules = [
        (../hosts + "/${hostname}")
        (hostPkgs localSystem)
        nixRegistry
        netHostMap
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        ragenix.nixosModules.age
      ];
      specialArgs = {
        inherit inputs;
      };
    };
in
lib.mapAttrs genConfiguration hosts
