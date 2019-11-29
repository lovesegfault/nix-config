{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/games.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../combo/xps-7590.nix
  ];

  networking.hostName = "wittgenstein";

  time.timeZone = "America/Los_Angeles";
}
