{ pkgs, ... }: {
  imports = [
    ../modules/alacritty.nix
    ../modules/dunst.nix
    ../modules/feh.nix
    ../modules/firefox.nix
    ../modules/gnome-keyring.nix
    ../modules/gpg-agent.nix
    ../modules/gtk.nix
    ../modules/i3.nix
    ../modules/i3status-rust.nix
    ../modules/polybar.nix
    ../modules/qt.nix
    ../modules/xresources.nix
    ../modules/xsession.nix
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
    yarn
  ];
}
