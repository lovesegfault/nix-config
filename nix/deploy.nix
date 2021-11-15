{ self
, agenix
, deploy-rs
, home-manager
, impermanence
, nixpkgs
, templates
, ...
}@inputs:
let
  inherit (nixpkgs.lib) mapAttrs' nameValuePair nixosSystem;

  genModules = hostName: system: [
    agenix.nixosModules.age
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager

    {
      nixpkgs = {
        localSystem.system = system;
        inherit (self.nixpkgs.${system}) overlays config;
      };

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

      networking.hosts = mapAttrs' (n: v: nameValuePair v.address [ n ]) (import ./hosts.nix);
    }

    (../hosts + "/${hostName}")
  ];

  mkHost = hostName: system: nixpkgs.lib.nixosSystem {
    modules = genModules hostName system;
    specialArgs.inputs = inputs;
  };

  mkActivation = hostName: localSystem:
    deploy-rs.lib.${localSystem}.activate.nixos (mkHost hostName localSystem);
in
{
  autoRollback = true;
  magicRollback = true;
  user = "root";
  nodes = builtins.mapAttrs
    (host: info: {
      hostname = info.address;
      profiles.system.path = mkActivation host info.localSystem;
    })
    (import ./hosts.nix);
}
