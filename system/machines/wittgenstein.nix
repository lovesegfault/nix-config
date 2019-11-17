{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/xps_7590.nix
  ];

  networking.hostName = "wittgenstein";

  time.timeZone = "America/Los_Angeles";
}
