{ self
, deploy-rs
, flake-utils
, nixpkgs
, sops-nix
, ...
}@inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    inherit (nixpkgs.lib) mapAttrs attrValues;
    pkgs = import nixpkgs { inherit system; };
    joinDrvs = pkgs.callPackage ./join-drvs.nix { };
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
      hosts = joinDrvs "hosts" (mapAttrs (_: v: v.profiles.system.path) self.deploy.nodes);
      images = joinDrvs "images" self.images;
    };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (sops-nix.packages.${system}) sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
  })
)
// (import ./deploy.nix inputs)
  // (import ./images.nix inputs)
