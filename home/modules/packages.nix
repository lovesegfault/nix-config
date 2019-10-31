{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arcanist
    bat
    exa
    fzf
    gist
    gnome3.seahorse
    gopass
    libnotify
    lollypop
    neofetch
    nix-index
    ripgrep
    nodejs
    yarn
    shotwell
    slack
    thunderbird
    weechat
    zoom-us
  ];
}
