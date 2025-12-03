# Shared system configuration for NixOS and Darwin
{ pkgs, ... }:
{
  imports = [
    ./aspell.nix
    ./theme.nix
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

  # We need this otherwise the autoimport clashes with our manual import.
  stylix.homeManagerIntegration.autoImport = false;
}
