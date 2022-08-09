{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev
    ../../dev/virt-manager.nix

    ../../hardware/nixos-aarch64-builder
    ../../hardware/thinkpad-z13.nix
    ../../hardware/yubikey.nix

    ../../graphical
    ../../graphical/trusted.nix

    ../../users/bemeurer

    ./state.nix
    ./sway.nix
  ];

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-uuid/f8e32b80-d520-4171-ade3-d6ddbf9363d0";
    allowDiscards = true;
  };

  environment.systemPackages = with pkgs; [ cntr wireguard-tools mullvad-vpn powertop ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/03D1-5AC1";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/9ea17c8d-62c0-44d8-952f-9438a3a46bf2";
      fsType = "ext4";
      options = [ "defaults" "noatime" "commit=15" ];
      neededForBoot = true;
    };
  };

  hardware.ledger.enable = true;

  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/trusted
      ../../users/bemeurer/trusted/graphical.nix
    ];
  };

  location = {
    provider = "geoclue2";
  };

  networking = {
    hostId = "a8766d75";
    hostName = "spinoza";
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
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
    };
    mullvad-vpn.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "04:7b:cb:b2:47:de";
      linkConfig.Multicast = true;
      networkConfig = {
        MulticastDNS = true;
        LLMNR = true;
      };
    };
  };

  systemd.user.services.geoclue-agent.after = [
    "network.target"
    "systemd-networkd-wait-online.service"
    "NetworkManager-wait-online.service"
  ];

  swapDevices = [{ device = "/dev/disk/by-uuid/6d3d9006-e2e9-4de9-b194-3481e7df506c"; }];

  time.timeZone = "America/New_York";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
