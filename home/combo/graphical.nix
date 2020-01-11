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
    gnome3.evince
    gopass
    libnotify
    pavucontrol
    shotwell
    slack
    speedcrunch
    spotify
    thunderbird
    zoom-us
  ] ++ (if pkgs.stdenv.isLinux then [ pkgs.discord ] else []);
}
