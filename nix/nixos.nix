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

  genConfiguration = hostname: { address, hostPlatform, ... }:
    lib.nixosSystem {
      modules = [
        (../hosts + "/${hostname}")
        {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            p.flake = nixpkgs;
            pkgs.flake = nixpkgs;
            templates.flake = templates;
          };
          nixpkgs = {
            pkgs = self.pkgs.${hostPlatform};
            # FIXME: This shouldn't be needed, but is for some reason it is.
            inherit hostPlatform;
          };
        }
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        ragenix.nixosModules.age
      ];
      specialArgs = {
        impermanence = impermanence.nixosModules;
        hardware = nixos-hardware.nixosModules;
        hostAddress = address;
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })
