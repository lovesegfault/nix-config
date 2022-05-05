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
      inherit (hosts.${hostName}) address localSystem;
      inherit (deploy-rs.lib.${localSystem}) activate;
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
