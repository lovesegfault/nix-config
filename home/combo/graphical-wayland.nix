{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/firefox.nix
    ../modules/gnome-keyring.nix
    ../modules/gpg-agent.nix
    ../modules/gtk.nix
    ../modules/mako.nix
    ../modules/qt.nix
    ../modules/sway.nix
    ../modules/swaylock.nix
    ../modules/waybar.nix
  ];

  home.packages = with pkgs; [
    gimp
    gnome3.evolution
    gnome3.seahorse
    gopass
    libnotify
    pavucontrol
    shotwell
    slack
    spotify
    sublime3
    vscode
    zoom-us
  ];
}
