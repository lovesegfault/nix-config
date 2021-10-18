{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/bluetooth.nix
    ../../hardware/rpi4.nix
    ../../hardware/sound-pipewire.nix

    ../../graphical
    ../../graphical/sway.nix

    ../../users/bemeurer

    ./sway.nix
  ];

  boot = {
    loader = {
      generic-extlinux-compatible.enable = lib.mkForce false;
      raspberryPi = {
        enable = true;
        firmwareConfig = ''
          dtparam=audio=on
          dtparam=spi=on
          dtoverlay=vc4-fkms-v3d

          dtoverlay=hyperpixel4-common
          dtoverlay=hyperpixel4-0x14,touchscreen-swapped-x-y,touchscreen-inverted-y
          dtoverlay=hyperpixel4-0x5d,touchscreen-swapped-x-y,touchscreen-inverted-y
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

  home-manager.users.bemeurer = { ... }: {
    wayland.windowManager.sway = {
      extraSessionCommands = ''
        export WLR_DRM_DEVICES=/dev/dri/card1
      '';
      config = {
        input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "us";
            repeat_rate = "70";
          };
        };
        output = {
          "DSI-1" = {
            mode = "480x800@60Hz";
            position = "0,0";
            subpixel = "rgb";
            transform = "90";
          };
        };
      };
    };
  };

  location = {
    latitude = 37.861;
    longitude = -122.273;
  };

  networking = {
    hostName = "aurelius";
    wireless.iwd.enable = true;
  };

  # the hyperpixel4 doesn't support standard brightness controls
  services.redshift.enable = lib.mkForce false;

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
