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

  mkHost = name: system: import ./mk-host.nix { inherit inputs name system; };

  mkPath = name: system: deploy-rs.lib.${system}.activate.nixos (mkHost name system);

  mkNode = name: system: hostname: {
    ${name} = {
      inherit hostname;
      profiles.system.path = mkPath name system;
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
        (s: foldl' (f: x: f x) mkNode s)
        [
          # [ "aurelius" "aarch64-linux" "aurelius" ]
          [ "cantor" "x86_64-linux" "100.76.151.127" ]
          [ "feuerbach" "x86_64-linux" "100.99.22.81" ]
          [ "foucault" "x86_64-linux" "100.67.182.67" ]
          [ "fourier" "x86_64-linux" "100.113.42.46" ]
          [ "goethe" "aarch64-linux" "100.125.185.48" ]
          [ "hegel" "x86_64-linux" "100.102.43.14" ]
          # [ "riemann" "aarch64-linux" "100.99.75.64" ]
          [ "sartre" "x86_64-linux" "100.97.215.77" ]
        ]
      );
  };

  checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
