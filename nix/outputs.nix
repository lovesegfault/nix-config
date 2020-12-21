{ self
, deploy-rs
, flake-utils
, nixpkgs
, sops-nix
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
      deploy = {
        type = "app";
        program = "${deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
      };
    };

    packages = {
      hosts = pkgs.linkFarmFromDrvs "nix-config" (mapAttrsToList (_: v: v.profiles.system.path) self.deploy.nodes);
      get-hosts = pkgs.callPackage ./get-hosts.nix { hosts = attrNames self.deploy.nodes; };
    };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (sops-nix.packages.${system}) ssh-to-pgp sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
  })) // (import ./deploy.nix inputs)
