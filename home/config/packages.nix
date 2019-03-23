{ config, pkgs, lib, ... }:
{
  config.home.packages = with pkgs; [
    arcanist
    beets
    exa
    fzf
    gnupg
    lynx
    nix-index
    ripgrep
    rustup
    skim
    texlive.combined.scheme-full
    travis
    (python3.withPackages(ps: with ps; [
      python-language-server
      ps.pyls-mypy
      ps.pyls-isort
      ps.pyls-black
    ]))
    llvmPackages_latest.clang-unwrapped
  ] ++ lib.optionals (config.isDesktop) [
    alacritty
    feh
    gopass
    grim
    i3status-rust
    jetbrains.clion
    light
    lollypop
    mako
    pavucontrol
    slack
    playerctl
    slurp
    spotify
    sway
    swayidle
    swaylock
    vlc
    wl-clipboard
    xdg_utils
    xorg.setxkbmap
    xorg.xhost
    zoom-us
  ];
}
