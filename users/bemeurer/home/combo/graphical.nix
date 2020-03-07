{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/firefox.nix
    ../modules/mpv.nix
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

  gtk = {
    enable = true;
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
  };
}
