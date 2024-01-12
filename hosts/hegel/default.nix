{ config, pkgs, nixos-hardware, ... }: {
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop-ssd

    ../../core

    ../../hardware/bluetooth.nix
    ../../hardware/efi.nix
    ../../hardware/sound.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../graphical
    ../../graphical/trusted.nix

    ../../services/virt-manager.nix

    ../../users/bemeurer

    ./state.nix
    ./sway.nix
  ];

  boot = {
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      systemd = {
        enable = true;
        services.rollback = {
          description = "Rollback ZFS datasets to a pristine state";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@blank && echo "rollback complete"
          '';
        };
      };
    };
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" "ddcci-backlight" "i2c-dev" "nct6775" ];
    kernelPackages = pkgs.linuxPackages_6_6;
    tmp.useTmpfs = true;
    plymouth.enable = true;
  };


  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  fileSystems = {
    "/" = {
      device = "zroot/local/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/754E-45C0";
      fsType = "vfat";
    };
    "/nix" = {
      device = "zroot/local/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/nix/state" = {
      device = "zroot/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/srv/music" = {
      device = "zroot/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "zroot/safe/pictures";
      fsType = "zfs";
    };
  };

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    ledger.enable = true;
    opengl.enable = true;
  };

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
    hostId = "872516b8";
    hostName = "hegel";
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  nix = {
    settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver3" ];
    gc = {
      automatic = true;
      dates = "02:30";
    };
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fwupd.enable = true;
    ratbagd.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    hardware.bolt.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      matchConfig.MACAddress = "3c:7c:3f:21:80:67";
      linkConfig.RequiredForOnline = "no";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "c8:e2:65:0a:7e:d1";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
      linkConfig.Multicast = true;
      networkConfig = {
        MulticastDNS = true;
        LLMNR = true;
      };
    };
  };

  stylix.fonts.sizes = {
    desktop = 16;
    applications = 14;
    terminal = 12;
    popups = 16;
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e4103056-9ef2-47da-8403-46cf20541b15"; }
    { device = "/dev/disk/by-uuid/4b74d5bd-3e62-4077-a126-6d73ad07267f"; }
  ];

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
