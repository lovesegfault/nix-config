{ pkgs, ... }: {
  imports = [
    ../modules/dunst.nix
    ../modules/feh.nix
    ../modules/i3.nix
    ../modules/i3status-rust.nix
    ../modules/polybar.nix
    ../modules/xresources.nix
    ../modules/xsession.nix
  ];
}
