{ lib, pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in {
  imports = [
    ../modules/boot_silent.nix
    ../modules/fonts.nix
    ../modules/gnome.nix
    ../modules/gdm.nix
    ../modules/gnome_keyring.nix
    ../modules/printing.nix
    ../modules/sound.nix
    ../modules/sway.nix
    ../modules/xserver.nix
  ];

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  nixpkgs.overlays = [ waylandOverlay ];

  services.xserver = {
    displayManager.gdm.wayland = true;
    videoDrivers = lib.mkForce [ "modesetting" ];
  };
}
