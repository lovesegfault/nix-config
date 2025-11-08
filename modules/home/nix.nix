{ flake, config, lib, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  # Nix flake registry
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };

  # NIX_PATH for legacy nix commands
  home.sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
    "nixpkgs=${config.xdg.dataHome}/nixpkgs"
  ];

  # Fish nix-env plugin
  programs.fish.plugins = [
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

  # Symlink nixpkgs to XDG data directory
  xdg.dataFile.nixpkgs.source = inputs.nixpkgs;

  # Custom nix.conf pointing to local registry
  xdg.configFile."nix/nix.conf".text = ''
    flake-registry = ${config.xdg.configHome}/nix/registry.json
  '';

  # Nix-index (comma disabled to match old config)
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = false;
}
