# NixOS configuration for spinoza
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index
    inputs.stylix.nixosModules.stylix

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-bemeurer
    self.nixosModules.hardware-secureboot
    self.nixosModules.hardware-thinkpad-z13
    self.nixosModules.hardware-yubikey
    self.nixosModules.graphical-default
    self.nixosModules.graphical-trusted
    self.nixosModules.services-virt-manager
    self.nixosModules.services-podman

    # Host-specific files
    ./state.nix
    ./sway.nix
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer.imports = [
    self.homeModules.trusted
    self.homeModules.trusted-graphical
  ];

  # SSH target for remote activation

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Nix registry
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };

  # Host-specific configuration
  boot = {
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    initrd = {
      kernelModules = [ "dm-snapshot" ];
      luks.devices.cryptroot = {
        allowDiscards = true;
        bypassWorkqueues = true;
        device = "/dev/disk/by-uuid/75fa9c3c-3b95-479b-ad90-32d83528524d";
      };
      systemd.enable = true;
    };
    plymouth.enable = true;
    resumeDevice = "/dev/cryptroot/swap";
  };

  environment.systemPackages = with pkgs; [
    cntr
    wireguard-tools
    powertop
  ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "noatime"
        "size=20%"
        "mode=755"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D506-6330";
      fsType = "vfat";
    };
    "/mnt/music-opus" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "discard=async"
        "subvol=music-opus"
      ];
      neededForBoot = true;
    };
    "/nix/state" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "discard=async"
        "compress=lzo"
        "subvol=nix/state"
      ];
      neededForBoot = true;
    };
    "/nix/store" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "discard=async"
        "compress=lzo"
        "subvol=nix/store"
      ];
      neededForBoot = true;
    };
    "/nix/var" = {
      device = "/dev/disk/by-uuid/8b6542d9-5407-418f-80ca-2dacd06655cb";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "discard=async"
        "compress=lzo"
        "subvol=nix/var"
      ];
      neededForBoot = true;
    };
  };

  hardware = {
    sane.enable = true;
    ledger.enable = true;
    graphics.extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  location.provider = "geoclue2";

  networking = {
    hostId = "a8766d75";
    hostName = "spinoza";
    wireguard.enable = true;
    wireless.iwd = {
      enable = true;
      settings.Rank = {
        BandModifier2_4GHz = 1.0;
        BandModifier5GHz = 2.0;
        BandModifier6GHz = 4.0;
      };
    };
  };

  nix.settings.max-substitution-jobs = 32;

  security = {
    pam.loginLimits = [
      {
        domain = "*";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "-";
        item = "nproc";
        value = "unlimited";
      }
    ];
    sudo.wheelNeedsPassword = true;
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/nix/state" ];
      interval = "weekly";
    };
    fstrim.enable = lib.mkForce false;
    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      submitData = false;
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
    };
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "suspend";
      HandleLidSwitchExternalPower = "ignore";
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "reboot";
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

  stylix = {
    cursor.size = 16;
    fonts.sizes = {
      desktop = 16;
      applications = 16;
      terminal = 18;
      popups = 20;
    };
  };

  systemd.user.services.geoclue-agent.after = [
    "network.target"
    "systemd-networkd-wait-online.service"
    "NetworkManager-wait-online.service"
  ];

  swapDevices = [ { device = "/dev/disk/by-uuid/898fb6e1-bba3-40ce-8f79-8deb2e2d4f37"; } ];

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
