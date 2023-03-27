{ self
, home-manager
, impermanence
, nix-index-database
, nixos-hardware
, nixpkgs
, ragenix
, stylix
, templates
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, ... }:
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
      ];
      specialArgs = {
        hostAddress = address;
        hostType = type;
        inherit home-manager impermanence nix-index-database nixos-hardware ragenix stylix;
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })
