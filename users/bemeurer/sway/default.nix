{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./mako.nix
    ./mpv.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    discord
    gimp
    gnome3.evince
    gnome3.shotwell
    grim
    imv
    libnotify
    pavucontrol
    slack
    slurp
    speedcrunch
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
