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
    (python3.withPackages(ps: with ps; [
      python-language-server
      ps.pyls-mypy
      ps.pyls-isort
      ps.pyls-black
    ]))
    llvmPackages_latest.clang-unwrapped
  ] ++ lib.optionals (config.isDesktop) [
    alacritty
    gopass
    i3status-rust
    jetbrains.clion
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
