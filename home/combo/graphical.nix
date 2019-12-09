{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/firefox.nix
    ../modules/gnome-keyring.nix
    ../modules/gpg-agent.nix
    ../modules/gtk.nix
    ../modules/qt.nix
  ];

  home.packages = with pkgs; [
    gimp
    gnome3.evince
    # gnome3.evolution
    gnome3.seahorse
    gopass
    libnotify
    pavucontrol
    shotwell
    slack
    spotify
    sublime3
    thunderbird
    vscode
    zoom-us
  ];
}
