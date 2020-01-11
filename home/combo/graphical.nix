{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/firefox.nix
    ../modules/mpv.nix
    ../modules/gtk.nix
    ../modules/qt.nix
  ];

  home.packages = with pkgs; [
    gimp
    libnotify
    speedcrunch
    discord
    gnome3.evince
    gnome3.shotwell
    pavucontrol
    slack
    spotify
    thunderbird
    zoom-us
  ];
}
