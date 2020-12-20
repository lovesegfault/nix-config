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
(flake-utils.lib.eachDefaultSystem (system:
  let
    inherit (builtins) attrNames;
    inherit (nixpkgs.lib) mapAttrsToList;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    defaultApp = self.apps.${system}.deploy;
    defaultPackage = self.packages.${system}.hosts;

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

    packages = {
      hosts = pkgs.linkFarmFromDrvs "nix-config" (mapAttrsToList (_: v: v.profiles.system.path) self.deploy.nodes);
      gen-ci = pkgs.callPackage ./gen-ci.nix { hosts = attrNames self.deploy.nodes; };
    };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (self.packages.${system}) gen-ci;
      inherit (sops-nix.packages.${system}) ssh-to-pgp sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
})) // (import ./deploy.nix inputs)
