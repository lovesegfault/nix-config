{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev

    ../../hardware/nixos-aarch64-builder
    ../../hardware/thinkpad-p1.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../graphical
    ../../graphical/trusted.nix
    ../../graphical/sway.nix

    ../../users/bemeurer

    ./state.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [ cntr wireguard-tools mullvad-vpn ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2CE0-CC14";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/6aa44989-7ada-4d74-9a6c-1c79297b5ef1";
      fsType = "xfs";
      neededForBoot = true;
    };
  };

  home-manager.users.bemeurer = {
    imports = [ ../../users/bemeurer/trusted ];
  };

  location = {
    provider = "geoclue2";
  };

  networking = {
    hostId = "872516b8";
    hostName = "foucault";
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      submitData = true;
    };
    logind.lidSwitchExternalPower = "ignore";
    mullvad-vpn.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "98:3b:8f:cf:62:82";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/47602bda-4e3a-489a-b403-83cd9c673d4e"; }];

  time.timeZone = "Atlantic/Canary";

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
