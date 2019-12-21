{ config, pkgs, ... }: {
  imports = [ ../combo/core.nix ../combo/rpi3.nix ];

  networking.hostName = "bohr";

  time.timeZone = "America/Los_Angeles";
}
