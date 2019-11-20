{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/games.nix
    ../combo/graphical.nix
    ../combo/x.nix
    ../combo/xps_7590.nix
  ];

  networking.hostName = "wittgenstein";

  time.timeZone = "America/Los_Angeles";
}
