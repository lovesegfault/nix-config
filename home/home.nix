{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  imports = [
    ./options.nix

    ./git.nix
    ./gtk.nix
    ./htop.nix
    ./neovim.nix
    ./packages.nix
    ./services.nix
    ./ssh.nix
    ./tmux.nix
    ./variables.nix
    ./xdg.nix
    ./zsh.nix
  ];

  isArm = false;
  isDesktop = true;
  # Only allow unfree on Desktops
  nixpkgs.config.allowUnfree = config.isDesktop;
}
