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
    gnome3.gnome-calendar
    gnome3.evolution
    gopass
    libnotify
    lollypop
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
