# Shared configuration for standalone home-manager hosts
# This module is imported by configurations/home/*/default.nix
{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
in
{
  home.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.dataHome}/nixpkgs";

  programs = {
    home-manager.enable = true;
    fish.plugins = [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          hash = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk";
        };
      }
    ];
  };

  xdg = {
    dataFile.nixpkgs.source = inputs.nixpkgs;
    configFile."nix/nix.conf".text = ''
      flake-registry = ${config.xdg.configHome}/nix/registry.json
    '';
  };
}
