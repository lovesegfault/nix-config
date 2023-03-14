{ self
, home-manager
, impermanence
, nix-index-database
, nixos-hardware
, nixpkgs
, ragenix
, templates
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, ... }:
    lib.nixosSystem {
      modules = [
        (../hosts + "/${hostname}")
        {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            p.flake = nixpkgs;
            templates.flake = templates;
          };
          nixpkgs.pkgs = self.pkgs.${hostPlatform};
        }
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        nix-index-database.nixosModules.nix-index
        ragenix.nixosModules.age
      ];
      specialArgs = {
        hostAddress = address;
        hardware = nixos-hardware.nixosModules;
        impermanence = impermanence.nixosModules;
        inherit nix-index-database;
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })
