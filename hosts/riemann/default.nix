{ config, lib, nixos-hardware, pkgs, ... }:
{
  imports = [
    # nixos-hardware.nixosModules.raspberry-pi-4

    ../../core

    # ../../hardware/nixos-aarch64-builder

    ../../services/nginx.nix
    ../../services/oauth2.nix

    ../../users/bemeurer
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
    ];
    kernelParams = [ "console=ttyS1,115200n8" ];
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
  };

  # This host does not use impermanence
  environment.persistence."/nix/state".enable = false;

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [ "noauto" ];
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "riemann";
    wireless.iwd.enable = true;
  };

  security = {
    acme.certs."mainsail.riemann.meurer.org" = { };
    polkit.enable = true;
  };

  services = {
    # XXX: dbus-broker seems broken on the RPi4 kernel
    dbus.implementation = lib.mkForce "dbus";
    klipper = {
      enable = true;
      mutableConfig = true;
      mutableConfigFolder = "/var/lib/moonraker/config";
      configFile = ./klipper.cfg;
      logFile = "/var/lib/klipper/klipper.log";
      user = "klipper";
      group = "klipper";
    };
    mainsail = {
      enable = true;
      hostName = "mainsail.riemann.meurer.org";
      nginx = {
        useACMEHost = "mainsail.riemann.meurer.org";
        kTLS = true;
        forceSSL = true;
      };
    };
    moonraker = {
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true;
      settings = {
        authorization = {
          cors_domains = [
            "*://my.mainsail.xyz"
            "*://*.lan"
            "*://*.local"
            "*://*.meurer.org"
          ];
          trusted_clients = [
            "10.0.0.0/8"
            "127.0.0.0/8"
            "192.168.0.0/16"
            "FE80::/10"
            "::1/128"
            "100.64.0.0/10" # tailscale
          ];
        };
        octoprint_compat = { };
        history = { };
        announcements.subscriptions = [ "mainsail" ];
        file_manager.enable_object_processing = true;
        update_manager = {
          enable_system_updates = [ false ];
        };
        "update_manager KAMP" = {
          type = "git_repo";
          channel = "dev";
          path = "/var/lib/moonraker/kamp";
          origin = "https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git";
          primary_branch = "main";
          is_system_service = false;
        };
      };
      user = "klipper";
      group = "klipper";
    };
    oauth2-proxy.nginx.virtualHosts.${config.services.mainsail.hostName} = { };
  };

  system.build.firmware = {
    btt-octopus-max-ez = pkgs.klipper-firmware.override {
      mcu = "btt-octopus-max-ez";
      firmwareConfig = ./btt-octopus-max-ez.config;
    };
    btt-sb2240 = pkgs.klipper-firmware.override {
      mcu = "btt-sb2240";
      firmwareConfig = ./btt-sb2240.config;
    };
  };

  systemd = {
    network = {
      links."10-can" = {
        matchConfig.Type = "can";
        linkConfig.TransmitQueueLength = 2048;
      };
      networks = {
        "10-can" = {
          matchConfig = {
            Property = "ID_SERIAL_SHORT=002A00195542501920393839";
            Type = "can";
          };
          canConfig = {
            BitRate = 1000000;
            RestartSec = 1;
          };
        };
        "10-lan" = {
          DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
          matchConfig.MACAddress = "dc:a6:32:b8:bb:aa";
          dhcpV4Config.RouteMetric = 10;
          dhcpV6Config.RouteMetric = 10;
        };
        "10-wifi" = {
          DHCP = "yes";
          matchConfig.MACAddress = "dc:a6:32:b8:bb:ab";
          dhcpV4Config.RouteMetric = 40;
          dhcpV6Config.RouteMetric = 40;
        };
      };
    };
    oomd.enable = false;
    services.moonraker.path = [ pkgs.git ];
  };

  swapDevices = lib.mkDefault [{
    device = "/swap";
    size = 2048;
  }];

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./password.age;

  users = {
    users = {
      root.hashedPasswordFile = config.age.secrets.rootPassword.path;
      klipper = {
        isSystemUser = true;
        group = "klipper";
      };
    };
    groups.klipper = { };
  };

}
