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
    inherit (nixpkgs.lib) mapAttrs attrValues;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    defaultApp = self.apps.${system}.deploy;
    defaultPackage = self.packages.${system}.hostsCombined;

    apps = {
      deploy = {
        type = "app";
        program = "${deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
      };
    };

    packages =
      let
        hostDrvs = mapAttrs (_: v: v.profiles.system.path) self.deploy.nodes;
      in
      hostDrvs // {
        hostsCombined = pkgs.linkFarmFromDrvs "nix-config" (attrValues hostDrvs);
      };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (sops-nix.packages.${system}) ssh-to-pgp sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
  })) // (import ./deploy.nix inputs)
