{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arcanist
    bat
    exa
    fzf
    gist
    gnome3.seahorse
    gopass
    gtk3-x11
    libnotify
    lollypop
    nix-index
    ripgrep
    shotwell
    skim
    slack
    weechat
  ];
}
