{ sources ? import ./nix/sources.nix {} }:
let
  mkSystem = cfg: system:
    let
      pkgs = import sources.nixpkgs { inherit system; };
    in (pkgs.nixos cfg);
  systems = {
    abel = mkSystem ./systems/abel.nix "x86_64-linux";
    bohr = mkSystem ./systems/bohr.nix "aarch64-linux";
    camus = mkSystem ./systems/camus.nix "aarch64-linux";
    cantor = mkSystem ./systems/cantor.nix "x86_64-linux";
    foucault = mkSystem ./systems/foucault.nix "x86_64-linux";
    peano = mkSystem ./systems/peano.nix "x86_64-linux";
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
