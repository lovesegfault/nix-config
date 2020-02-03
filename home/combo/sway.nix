{ pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in {
  imports = [
    ../modules/mako.nix
    ../modules/sway.nix
    ../modules/swaylock.nix
    ../modules/waybar.nix
  ];

  home.packages = with pkgs; [ imv ];

  nixpkgs.overlays = [ waylandOverlay ];
}
