{ self
, ...
}@inputs:
let
  inherit (builtins) elemAt mapAttrs;

  mkHost = name: system: import ./mk-host.nix inputs { inherit name system; };

  mkPath = name: system: self.nixpkgs.deploy-rs.lib.activate.nixos (mkHost name system);
in
{
  deploy = {
    autoRollback = true;
    magicRollback = true;
    user = "root";
    nodes = mapAttrs
      (n: v: {
        inherit (v) hostname;
        profiles.system.path = mkPath n v.system;
      })
      (import ./hosts.nix);
  };
}
