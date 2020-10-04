{ lib, pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  boot = {
    loader = {
      generic-extlinux-compatible.enable = lib.mkForce false;
      raspberryPi = {
        enable = true;
        firmwareConfig = ''
          dtoverlay=vc4-fkms-v3d
          dtoverlay=hyperpixel4-common
          dtoverlay=hyperpixel4-0x14
          dtoverlay=hyperpixel4-0x5d
          enable_dpi_lcd=1
          dpi_group=2
          dpi_mode=87
          dpi_output_format=0x7f216
          dpi_timings=480 0 10 16 59 800 0 15 113 15 0 0 0 60 0 32000000 6
        '';
        version = 4;
      };
    };
    initrd = {
      extraUtilsCommands = "copy_bin_and_libs ${pkgs.hyperpixel4-init}/bin/hyperpixel4-init";
      preDeviceCommands = "hyperpixel4-init";
    };
    kernelParams = [ "fbcon=rotate:1" ];
  };

  fileSystems = lib.mkForce {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "aurelius";
    wireless.iwd.enable = true;
  };

  nixpkgs.overlays = [ (import ../overlays/hyperpixel.nix) ];

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:63:ac:71";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "dc:a6:32:63:ac:72";
    };
  };


  time.timeZone = "America/Los_Angeles";
}
