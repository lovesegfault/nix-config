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
  inherit (nixpkgs.lib) filterAttrs mapAttrs' nameValuePair nixosSystem;

  hosts = filterAttrs (_: v: !(v.hmOnly or false)) (import ./hosts.nix);

  genModules = hostName: system: [
    ragenix.nixosModules.age
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager

    {
      nixpkgs = {
        localSystem.system = system;
        inherit (self.legacyPackages.${system}) overlays config;
      };

      nix.registry = {
        templates.flake = templates;
        nixpkgs.flake = nixpkgs;
      };

      networking.hosts = mapAttrs' (n: v: nameValuePair v.address [ n ]) hosts;
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
    hosts;
}
