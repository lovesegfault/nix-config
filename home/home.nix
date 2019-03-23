{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./config/options.nix

    ./config/beets.nix
    ./config/git.nix
    ./config/gtk.nix
    ./config/htop.nix
    ./config/neovim.nix
    ./config/packages.nix
    ./config/qt.nix
    ./config/services.nix
    ./config/rofi.nix
    ./config/ssh.nix
    ./config/systemd.nix
    ./config/tmux.nix
    ./config/variables.nix
    ./config/xdg.nix
    ./config/xresources.nix
    ./config/xsession.nix
    ./config/zsh.nix
  ];

  isArm = false;
  isDesktop = true;
  iwFace = "wlp3s0";
  bgImage = "${config.home.homeDirectory}/pictures/walls/ocean.jpg";
  # Only allow unfree on Desktops
  nixpkgs.config.allowUnfree = config.isDesktop;
}
