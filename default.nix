{ sources ? import ./nix/sources.nix {} }:
let
  home-manager = import (sources.home-manager + "/nixos");
  pkgs = import sources.nixpkgs {};
  systemPkg = system: arch:
    (
      import ( sources.nixpkgs + "/nixos" ) {
        configuration = system;
        system = arch;
      }
    ).system;
  systems = {
    abel = systemPkg ./systems/abel.nix "x86_64-linux";
    bohr = systemPkg ./systems/bohr.nix "aarch64-linux";
    camus = systemPkg ./systems/camus.nix "aarch64-linux";
    cantor = systemPkg ./systems/cantor.nix "x86_64-linux";
    foucault = systemPkg ./systems/foucault.nix "x86_64-linux";
    peano = systemPkg ./systems/peano.nix "x86_64-linux";
  };
in
rec {
  x86_64 = with systems; [ abel cantor foucault peano ];
  aarch64 = with systems; [ bohr camus ];

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
} // systems
