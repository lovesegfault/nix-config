{ sources ? import ./nix/sources.nix {} }:
let
  home-manager = import (sources.home-manager + "/home-manager/home-manager.nix");
  pkgs = import sources.nixpkgs {};
  system = import ./system { inherit pkgs; };
  home = import ./home { inherit home-manager pkgs; };
  machines = pkgs.lib.zipAttrs [ system home ];
in
rec {
  inherit system home;
  x86_64 = with machines; [ abel cantor foucault peano ];
  aarch64 = with machines; [ bohr camus ];
  darwin = with machines; [ spinoza ];

  shellHack = let
    drv = import ./shell.nix {};
    nixConfig = import <nix/config.nix>;
  in derivation (
    drv.drvAttrs // {
      name = "shell-hack-${drv.name}";
      origBuilder = drv.builder;
      builder = builtins.storePath nixConfig.shell;
      origSystem = drv.system;
      system = builtins.currentSystem;
      origPATH = drv.PATH or "";
      PATH = builtins.storePath nixConfig.coreutils;
      origArgs = drv.args;
      args = [
        (
          builtins.toFile "keep-env-hack" ''
            env > $out
          ''
        )
      ];
    }
  );
} // machines
