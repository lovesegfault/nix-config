{ self
, deploy-rs
, flake-utils
, home-manager
, impermanence
, nixpkgs
, sops-nix
, ...
}@inputs:
let
  inherit (builtins) attrNames attrValues elemAt listToAttrs mapAttrs readDir;

  overlays = map (f: import (./overlays + "/${f}")) (attrNames (readDir ./overlays));

  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({ nixpkgs = { inherit overlays; }; })
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops

        (./hosts + "/${name}")
      ];
      specialArgs.inputs = inputs;
    };

  genHosts = hosts:
    listToAttrs
      (map
        (p: {
          name = elemAt p 0;
          value = mkHost (elemAt p 0) (elemAt p 1);
        })
        hosts
      );
in
{
  nixosConfigurations = genHosts [
    # [ "aurelius" "aarch64-linux" ]
    [ "feuerbach" "x86_64-linux" ]
    [ "foucault" "x86_64-linux" ]
    [ "fourier" "x86_64-linux" ]
    [ "goethe" "aarch64-linux" ]
    [ "riemann" "aarch64-linux" ]
    [ "sartre" "x86_64-linux" ]
  ];

  deploy = {
    autoRollback = true;
    magicRollback = true;
    nodes = mapAttrs
      (_: nixosConfig: {
        hostname = nixosConfig.config.networking.hostName;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfig;
        };
      })
      self.nixosConfigurations;
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
