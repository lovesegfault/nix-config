{ self
, deploy-rs
, home-manager
, impermanence
, nixpkgs
, sops-nix
, ...
}@inputs:
let
  inherit (nixpkgs.lib) foldl' foldr;
  inherit (builtins) elemAt mapAttrs;

  mkHost = { name, system, ... }: import ./mk-host.nix { inherit inputs name system; };

  mkPath = { name, system, ... }@host: deploy-rs.lib.${system}.activate.nixos (mkHost host);

  mkNode = { name, system, hostname, ... }@host: {
    ${name} = {
      inherit hostname;
      profiles.system.path = mkPath host;
    };
  };
in
{
  deploy = {
    autoRollback = true;
    magicRollback = true;
    user = "root";
    nodes = foldr
      (a: b: a // b)
      { }
      (map
        (h: mkNode h)
        (import ./hosts.nix)
      );
  };

  checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
