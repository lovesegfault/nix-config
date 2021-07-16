{ self
, deploy-rs
, flake-utils
, nixpkgs
, pre-commit-hooks
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
    };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (sops-nix.packages.${system}) sops-import-keys-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
      inherit (self.checks.${system}) pre-commit-check;
    };

    checks = (deploy-rs.lib."${system}".deployChecks self.deploy) // {
      pre-commit-check = pre-commit-hooks.lib."${system}".run {
        src = ./.;
        hooks = {
          nixpkgs-fmt = {
            enable = true;
            excludes = [ "linux-lto.nix" ];
          };
          nix-linter = {
            enable = true;
            excludes = [ "flake.nix" ];
          };
          stylua = {
            enable = true;
            name = "stylua";
            entry = "${pkgs.stylua}/bin/stylua";
            types = [ "file" "lua" ];
          };
          luacheck = {
            enable = true;
            name = "luacheck";
            entry = "${pkgs.luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
            types = [ "file" "lua" ];
          };
        };
      };
    };
  })
)
  // (import ./deploy.nix inputs)
