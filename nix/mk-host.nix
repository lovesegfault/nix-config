{ self
, agenix
, home-manager
, impermanence
, nixpkgs
, templates
, ...
}@inputs:

{ name
, system
, extraModules ? [ ]
}:
let
  inherit (nixpkgs.lib) nixosSystem mapAttrs' nameValuePair;
in
nixosSystem {
  inherit system;

  modules = [
    agenix.nixosModules.age
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager

    { nixpkgs = { inherit (self.nixpkgs) config overlays; }; }

    {
      nix.registry = {
        self.flake = self;
        template = {
          flake = templates;
          from = {
            id = "templates";
            type = "indirect";
          };
        };
        nixpkgs = {
          flake = nixpkgs;
          from = {
            id = "nixpkgs";
            type = "indirect";
          };
        };
      };
    }

    {
      networking.hosts = mapAttrs' (n: v: nameValuePair v.hostname [ n ]) (import ./hosts.nix);
    }

    (../hosts + "/${name}")
  ] ++ extraModules;

  specialArgs.inputs = inputs;
}
