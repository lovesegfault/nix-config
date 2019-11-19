{ pkgs, ... }: {
  imports = [
    ../pkgs/bimp.nix
    ../pkgs/swaymenu.nix
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
    mosh
    neofetch
    nix-index
    nodejs
    passmenu
    pavucontrol
    prtsc
    ranger
    ripgrep
    shotwell
    slack
    spotify
    sublime3
    swaymenu
    tealdeer
    vscode
    weechat
    yarn
    zoom-us
  ];
}
