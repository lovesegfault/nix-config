{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../combo/optiplex-3070.nix
  ];

  networking.hostName = "comte";

  time.timeZone = "America/Los_Angeles";
}
