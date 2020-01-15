{ lib, ... }: {
  imports = [
    ../combo/core.nix

    ../hardware/rpi3.nix
  ];

  networking.hostName = "camus";

  time.timeZone = "America/Los_Angeles";
}
