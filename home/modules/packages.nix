{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arcanist
    bat
    beets
    exa
    fzf
    gimp
    gist
    gnome3.seahorse
    gnome3.evolution
    gopass
    libnotify
    lollypop
    mosh
    neofetch
    nix-index
    nodejs
    pavucontrol
    ripgrep
    shotwell
    slack
    thunderbird
    weechat
    yarn
    zoom-us
  ];
}
