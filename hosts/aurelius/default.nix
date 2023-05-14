{ config, lib, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4

    ../../core

    # ../../hardware/nixos-aarch64-builder
    # ../../hardware/bluetooth.nix
    # ../../hardware/sound-pipewire.nix

    # ../../graphical

    ../../users/bemeurer

    # ./sway.nix
    ./hyperpixel4.nix
  ];

  boot.blacklistedKernelModules = [ "i2c_gpio" "spi_gpio" "goodix" ];

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
  };

  location.provider = "geoclue2";

  networking = {
    hostName = "aurelius";
    wireless.iwd = {
      enable = true;
      settings.General.Country = "US";
    };
  };

  services = {
    automatic-timezoned.enable = true;
    # XXX: dbus-broker seems broken on the RPi4 kernel
    dbus.implementation = lib.mkForce "dbus";
    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      submitData = true;
    };
  };

  swapDevices = lib.mkDefault [{
    device = "/swap";
    size = 2048;
  }];

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:63:ac:71";
      dhcpV4Config.RouteMetric = 10;
      dhcpV6Config.RouteMetric = 10;
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "dc:a6:32:63:ac:72";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
    };
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
