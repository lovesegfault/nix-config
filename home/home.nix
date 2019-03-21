{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./config/options.nix

    ./config/git.nix
    ./config/gtk.nix
    ./config/htop.nix
    ./config/neovim.nix
    ./config/packages.nix
    ./config/services.nix
    ./config/ssh.nix
    ./config/tmux.nix
    ./config/variables.nix
    ./config/xdg.nix
    ./config/zsh.nix
  ];

  isArm = false;
  isDesktop = true;
  # Only allow unfree on Desktops
  nixpkgs.config.allowUnfree = config.isDesktop;
}
