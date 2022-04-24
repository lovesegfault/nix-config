{ self
, deploy-rs
, nixpkgs
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).allHosts;

  genNode = hostName: nixosCfg:
    let
      inherit (hosts.${hostName}) address localSystem;
      activate = deploy-rs.lib.${localSystem}.activate;
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
