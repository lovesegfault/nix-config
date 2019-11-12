{ config, pkgs, ... }:

{
  imports = [
    # modules/dunst.nix
    # modules/gpg-agent.nix
    # modules/gpg.nix
    # modules/i3.nix
    # modules/i3status-rust.nix
    # modules/polybar.nix
    # modules/rofi.nix
    # modules/ssh.nix
    # modules/xresources.nix
    # modules/xsession.nix
    modules/alacritty.nix
    modules/bat.nix
    modules/firefox.nix
    modules/git.nix
    modules/gnome-keyring.nix
    modules/gtk.nix
    modules/home.nix
    modules/htop.nix
    modules/mako.nix
    modules/libinput-gestures.nix
    modules/neovim.nix
    modules/newsboat.nix
    modules/packages.nix
    modules/qt.nix
    modules/sway.nix
    modules/swaylock.nix
    modules/tmux.nix
    modules/waybar.nix
    modules/xdg.nix
    modules/zsh.nix
  ];

  programs.home-manager.enable = true;
}
