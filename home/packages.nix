{ config, pkgs, lib, ... }:
{
  config.home.packages = with pkgs; [
    arcanist
    beets
    exa
    gnupg
    lynx
    nix-index
    ripgrep
    rustup
    skim
    texlive.combined.scheme-full
    travis
  ] ++ lib.optionals (config.isDesktop) [
    alacritty
    i3status-rust
    lollypop
    mako
    pavucontrol
    slack
    spotify
    sway
    swayidle
    swaylock
    vlc
    zoom-us
  ];
}
