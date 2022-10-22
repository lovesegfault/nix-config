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

  boot = {
    plymouth.enable = true;
    initrd = {
      systemd.enable = true;
      luks.devices.cryptroot = {
        device = "/dev/disk/by-uuid/f8e32b80-d520-4171-ade3-d6ddbf9363d0";
        allowDiscards = true;
      };
    };
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
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "compress=zstd" "subvol=nix" ];
      neededForBoot = true;
    };
    "/nix/state" = {
      device = "/dev/disk/by-uuid/9ea17c8d-62c0-44d8-952f-9438a3a46bf2";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "compress=zstd" "subvol=state" ];
      neededForBoot = true;
    };
  };

  hardware.ledger.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    libvdpau-va-gl
    vaapiVdpau
  ];

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

  nixpkgs.overlays = [ (import ./optimized-pkgs.nix) ];

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/nix" ];
      interval = "weekly";
    };
    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      submitData = true;
    };
    localtimed.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
    };
    mullvad-vpn.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    udisks2.enable = true;
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    anker = {
      DHCP = "yes";
      matchConfig.MACAddress = "f8:e4:3b:a9:9d:e2";
      linkConfig = {
        MTUBytes = "1400";
        Multicast = true;
        RequiredForOnline = "routable";
      };
      networkConfig = {
        MulticastDNS = true;
        LLMNR = true;
      };
    };
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

  security.sudo.wheelNeedsPassword = true;

  services.pipewire.package = pkgs.pipewire-optimized;
  # FIXME: Breaks systemd-boot?
  # systemd.package = pkgs.systemd-optimized;

  systemd.user.services.geoclue-agent.after = [
    "network.target"
    "systemd-networkd-wait-online.service"
    "NetworkManager-wait-online.service"
  ];

  swapDevices = [{ device = "/dev/disk/by-uuid/6d3d9006-e2e9-4de9-b194-3481e7df506c"; }];

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
