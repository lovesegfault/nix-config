{ self
, deploy-rs
, home-manager
, impermanence
, nixpkgs
, ragenix
, templates
, ...
}@inputs:
let
  inherit (nixpkgs.lib) mapAttrs' nameValuePair nixosSystem;

  genModules = hostName: system: [
    ragenix.nixosModules.age
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager

    {
      nixpkgs = {
        localSystem.system = system;
        inherit (self.nixpkgs.${system}) overlays config;
      };

      nix.registry = {
        templates.flake = templates;
        nixpkgs.flake = nixpkgs;
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
