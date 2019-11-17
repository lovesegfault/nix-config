{ config, pkgs, ... }: {
  imports = [
    ../pkgs/bimp.nix
    ../pkgs/menew.nix
    ../pkgs/passmenu.nix
    ../pkgs/prtsc.nix
    ../pkgs/emojimenu.nix
  ];

  home.packages = with pkgs; [
    arcanist
    bat
    beets
    bimp
    exa
    fzf
    gimp
    gist
    gnome3.evolution
    gnome3.seahorse
    gopass
    libnotify
    lollypop
    menew
    mosh
    neofetch
    nix-index
    nodejs
    passmenu
    pavucontrol
    prtsc
    ripgrep
    shotwell
    slack
    spotify
    thunderbird
    weechat
    yarn
    zoom-us
  ];
}
