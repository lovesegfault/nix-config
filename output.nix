{ self
, deploy-rs
, flake-utils
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

        (./hosts + "/${name}")
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
      # feuerbach = {
      #   hostname = "stcg-us-0005-11";
      #   profiles.system.path = mkPath "feuerbach" "x86_64-linux";
      # };
      foucault = {
        hostname = "foucault";
        profiles.system.path = mkPath "foucault" "x86_64-linux";
      };
      fourier = {
        hostname = "fourier";
        profiles.system.path = mkPath "fourier" "x86_64-linux";
      };
      goethe = {
        hostname = "goethe";
        profiles.system.path = mkPath "goethe" "aarch64-linux";
      };
      riemann = {
        hostname = "riemann";
        profiles.system.path = mkPath "riemann" "aarch64-linux";
      };
      sartre = {
        hostname = "sartre.meurer.org";
        profiles.system.path = mkPath "sartre" "x86_64-linux";
      };
    };
  };

  checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
} // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    defaultApp = self.apps.${system}.deploy;

    apps = {
      gen-ci = {
        type = "app";
        program = "${self.packages."${system}".gen-ci}/bin/gen-ci";
      };
      deploy = {
        type = "app";
        program = "${deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
      };
    };

    packages.gen-ci = pkgs.callPackage ./gen-ci.nix { hosts = attrNames self.deploy.nodes; };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (self.packages.${system}) gen-ci;
      inherit (sops-nix.packages.${system}) ssh-to-pgp sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
  })
