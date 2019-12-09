{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/packet.nix
  ];

  networking.hostName = "cantor";

  time.timeZone = "America/Los_Angeles";
}
