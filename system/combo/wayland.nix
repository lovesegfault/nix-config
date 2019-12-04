{ lib, pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in {
  imports = [ ../modules/sway.nix ];

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  nixpkgs.overlays = [ waylandOverlay ];

  services.xserver.displayManager.gdm.nvidiaWayland = true;
  services.xserver.displayManager.gdm.wayland = true;
}
