{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/games.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    # ../combo/x.nix
    ../combo/thinkpad-p1.nix

    ../modules/aarch64-build-box.nix
    ../modules/stcg-cameras.nix
  ];

  networking.hostName = "foucault";

  time.timeZone = "America/Los_Angeles";
}
