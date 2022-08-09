{ self
, deploy-rs
, nixpkgs
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).all;

  genNode = hostName: nixosCfg:
    let
      inherit (hosts.${hostName}) address hostPlatform;
      inherit (deploy-rs.lib.${hostPlatform}) activate;
    in
    {
      hostname = address;
      profiles.system.path = activate.nixos nixosCfg;
    };
in
{
  autoRollback = true;
  magicRollback = true;
  user = "root";
  nodes = lib.mapAttrs genNode self.nixosConfigurations;
}
