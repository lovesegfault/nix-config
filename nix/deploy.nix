{ self
, deploy-rs
, home-manager
, impermanence
, nixpkgs
, sops-nix
, staging
, ...
}@inputs:
let
  inherit (builtins) attrNames mapAttrs readDir;

  overlays = map (f: import (./overlays + "/${f}")) (attrNames (readDir ./overlays));

  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({ nixpkgs = { inherit overlays; }; })
        ({ systemd.package = (import staging { inherit system; }).systemd; })
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops

        (../hosts + "/${name}")
      ];
      specialArgs.inputs = inputs;
    };

  mkPath = name: system: deploy-rs.lib.${system}.activate.nixos (mkHost name system);
in
{
  deploy = {
    autoRollback = true;
    magicRollback = true;
    user = "root";
    nodes = {
      # aurelius = {
      #   hostname = "aurelius";
      #   profiles.system.path = mkPath "aurelius" "aarch64-linux";
      # };
      feuerbach = {
        hostname = "stcg-us-0005-11";
        profiles.system.path = mkPath "feuerbach" "x86_64-linux";
      };
      foucault = {
        hostname = "100.67.182.67";
        profiles.system.path = mkPath "foucault" "x86_64-linux";
        magicRollback = false;
      };
      fourier = {
        hostname = "100.113.42.46";
        profiles.system.path = mkPath "fourier" "x86_64-linux";
      };
      goethe = {
        hostname = "100.125.185.48";
        profiles.system.path = mkPath "goethe" "aarch64-linux";
      };
      riemann = {
        hostname = "100.99.75.64";
        profiles.system.path = mkPath "riemann" "aarch64-linux";
      };
      sartre = {
        hostname = "100.97.215.77";
        profiles.system.path = mkPath "sartre" "x86_64-linux";
      };
    };
  };

  checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
