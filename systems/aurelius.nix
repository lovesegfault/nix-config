{ lib, pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  boot.kernelParams = [ "fbcon=rotate:1" ];

  networking = {
    hostName = "aurelius";
    wireless.iwd.enable = true;
  };

  nixpkgs.overlays = [ (import ../overlays/hyperpixel.nix) ];

  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.hyperpixel4-hack}/bin/hyperpixel4-hack
    copy_bin_and_libs ${pkgs.hyperpixel4-init}/bin/hyperpixel4-init
  '';
  boot.initrd.preDeviceCommands = ''
    hyperpixel4-hack
    hyperpixel4-init
  '';

  time.timeZone = "America/Los_Angeles";
}
