{ config, pkgs, ... }:

{
  imports = [
    modules/alacritty.nix
    modules/dunst.nix
    modules/firefox.nix
    modules/git.nix
    modules/gnome-keyring.nix
    modules/gpg-agent.nix
    modules/gpg.nix
    modules/gtk.nix
    modules/htop.nix
    modules/i3.nix
    modules/neovim.nix
    modules/newsboat.nix
    modules/packages.nix
    # modules/polybar.nix
    modules/qt.nix
    modules/rofi.nix
    modules/ssh.nix
    modules/tmux.nix
    modules/xdg.nix
    modules/xresources.nix
    modules/xsession.nix
    modules/zsh.nix
  ];

  programs.home-manager.enable = true;
}
