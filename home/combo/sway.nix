{ pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in
{
  imports = [
    ../modules/mako.nix
    ../modules/sway.nix
    ../modules/swaylock.nix
    ../modules/waybar.nix

    ../pkgs/emojimenu.nix
    ../pkgs/otpmenu.nix
    ../pkgs/passmenu.nix
    ../pkgs/prtsc.nix
    ../pkgs/swaymenu.nix
  ];

  home.packages = with pkgs; [ imv ];

  nixpkgs.overlays = [ waylandOverlay ];
}
