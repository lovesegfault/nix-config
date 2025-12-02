# Shared system configuration for NixOS and Darwin
{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    ./aspell.nix
  ];

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    info.enable = true;
  };

  environment = {
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      neovim
      rsync
    ];
  };

  programs = {
    nix-index.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${inputs.tinted-schemes}/base16/ayu-dark.yaml";
    # We need this otherwise the autoimport clashes with our manual import.
    homeManagerIntegration.autoImport = false;
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
  };
}
