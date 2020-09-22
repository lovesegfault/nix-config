{ lib, pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  boot = {
    loader = {
      # NB: We _must_ use the oldschool bootloader in order to have hyperpixel
      # working
      generic-extlinux-compatible.enable = lib.mkForce false;
      raspberryPi = {
        enable = true;
        version = 4;
        firmwareConfig = ''
          gpu_mem=192
          dtoverlay=hyperpixel4-common
          enable_dpi_lcd=1
          dpi_group=2
          dpi_mode=87
          dpi_output_format=0x7f216
          dpi_timings=480 0 10 16 59 800 0 15 113 15 0 0 0 60 0 32000000 6
        '';
      };
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

  systemd.services.hyperpixel4-init = {
    after = [ "local-fs.target" ];
    description = "HyperPixel 4.0\" LCD Display Initialization";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.hyperpixel4-init}/bin/hyperpixel4-init";
  };

  time.timeZone = "America/Los_Angeles";
}
