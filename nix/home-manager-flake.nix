{ nixpkgs, templates, ... }:
{ config, ... }: {
  nix.registry = {
    templates.flake = templates;
    nixpkgs.flake = nixpkgs;
  };

  systemd.user.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.dataHome}/nixpkgs:nixpkgs-overlays=${config.xdg.dataHome}/overlays\${NIX_PATH:+:}$NIX_PATH";

  xdg = {
    dataFile = {
      nixpkgs.source = nixpkgs;
      overlays.source = ../nix/overlays;
    };
    configFile."nix/nix.conf".text = ''
      flake-registry = ${config.xdg.configHome}/nix/registry.json
    '';
  };
}
