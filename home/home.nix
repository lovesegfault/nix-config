{ config, pkgs, ... }:

{
  imports = [
    # modules/dunst.nix
    # modules/i3.nix
    # modules/i3status-rust.nix
    # modules/polybar.nix
    # modules/rofi.nix
    modules/alacritty.nix
    modules/bat.nix
    modules/firefox.nix
    modules/git.nix
    modules/gnome-keyring.nix
    modules/gpg-agent.nix
    modules/gpg.nix
    modules/gtk.nix
    modules/htop.nix
    modules/mako.nix
    modules/neovim.nix
    modules/newsboat.nix
    modules/packages.nix
    modules/qt.nix
    modules/ssh.nix
    modules/sway.nix
    modules/swaylock.nix
    modules/tmux.nix
    modules/xdg.nix
    modules/xresources.nix
    modules/xsession.nix
    modules/zsh.nix
  ];

  programs.home-manager.enable = true;
}
