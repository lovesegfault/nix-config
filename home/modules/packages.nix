{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arcanist
    bat
    exa
    fzf
    gimp
    gist
    gnome3.seahorse
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
