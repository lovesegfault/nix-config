{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/firefox.nix
    ../modules/gnome-keyring.nix
    ../modules/gpg-agent.nix
    ../modules/mpv.nix
    ../modules/gtk.nix
    ../modules/qt.nix
  ];

  home.packages = with pkgs; [
    discord
    gimp
    gnome3.evince
    gnome3.seahorse
    gopass
    libnotify
    pavucontrol
    shotwell
    slack
    speedcrunch
    spotify
    thunderbird
    zoom-us
  ];
}
