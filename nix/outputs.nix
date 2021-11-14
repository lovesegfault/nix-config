{ self
, agenix
, deploy-rs
, nixpkgs
, pre-commit-hooks
, ...
}@inputs:
let
  system = "x86_64-linux";

  inherit (builtins) attrNames readDir;
  inherit (self.nixpkgs.lib) joinHostDrvs mapAttrs;
in
{
  defaultPackage.${system} = self.packages.${system}.hosts;

  packages.${system}.hosts = joinHostDrvs "hosts"
    (mapAttrs (_: v: v.profiles.system.path) self.deploy.nodes);

  devShell.${system} = self.nixpkgs.callPackage ./shell.nix {
    inherit (deploy-rs.packages.${system}) deploy-rs;
    inherit (self.checks.${system}) pre-commit-check;
  };

  nixpkgs = import nixpkgs {
    inherit system;

    overlays = (map
      (f: import (./overlays + "/${f}"))
      (attrNames (readDir ./overlays)))
    ++ [ agenix.overlay ];

    config = {
      allowUnfree = true;
      allowAliases = true;
    };
  };


  checks.${system} = (deploy-rs.lib."${system}".deployChecks self.deploy) // {
    pre-commit-check = pre-commit-hooks.lib."${system}".run {
      src = ../.;
      hooks = {
        nixpkgs-fmt.enable = true;
        nix-linter = {
          enable = true;
          excludes = [ "flake.nix" ];
        };
        stylua = {
          enable = true;
          name = "stylua";
          entry = "${self.nixpkgs.stylua}/bin/stylua";
          types = [ "file" "lua" ];
        };
        luacheck = {
          enable = true;
          name = "luacheck";
          entry = "${self.nixpkgs.luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
          types = [ "file" "lua" ];
        };
      };
    };
  };
} // (import ./deploy.nix inputs)
