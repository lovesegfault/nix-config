{ config, pkgs, ... }: {
  imports = [
    ../core
    ../dev

    ../misc/efi.nix
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  time.timeZone = "America/Los_Angeles";
}
