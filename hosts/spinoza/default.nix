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
    initrd = {
      kernelModules = [ "dm-snapshot" ];
      luks.devices.cryptroot = {
        device = "/dev/disk/by-uuid/75fa9c3c-3b95-479b-ad90-32d83528524d";
        allowDiscards = true;
      };
      systemd.enable = true;
    };
    plymouth.enable = true;
    resumeDevice = "/dev/cryptroot/swap";
  };


  environment.systemPackages = with pkgs; [ cntr wireguard-tools powertop ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D506-6330";
      fsType = "vfat";
    };
    "/mnt/music-opus" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "subvol=music-opus" ];
      neededForBoot = true;
    };
    "/nix/state" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "compress=zstd" "subvol=nix/state" ];
      neededForBoot = true;
    };
    "/nix/store" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "compress=zstd" "subvol=nix/store" ];
      neededForBoot = true;
    };
    "/nix/var" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "discard=async" "subvol=nix/var" ];
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
    automatic-timezoned.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/nix/store" "/nix/state" "/nix/var" ];
      interval = "weekly";
    };
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
    udev.packages = with pkgs; [ logitech-udev-rules ];
    udisks2.enable = true;
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    anker = {
      DHCP = "yes";
      matchConfig.MACAddress = "f8:e4:3b:a9:9d:e2";
      dhcpV4Config.RouteMetric = 20;
      dhcpV6Config.RouteMetric = 20;
      linkConfig = {
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
      matchConfig.MACAddress = "04:7b:cb:29:02:d2";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
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

  swapDevices = [{ device = "/dev/disk/by-uuid/898fb6e1-bba3-40ce-8f79-8deb2e2d4f37"; }];

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
