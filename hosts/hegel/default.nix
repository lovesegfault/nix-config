{ config, lib, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev
    ../../dev/virt-manager.nix

    ../../hardware/bluetooth.nix
    ../../hardware/efi.nix
    ../../hardware/nixos-aarch64-builder
    ../../hardware/sound-pipewire.nix
    ../../hardware/vial.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../graphical
    ../../graphical/i3.nix
    ../../graphical/sway.nix
    ../../graphical/trusted.nix

    ../../users/bemeurer

    ./i3.nix
    ./state.nix
    ./sway.nix
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/local/root@blank
      '';
    };
    kernel.sysctl."vm.swappiness" = 1;
    kernel.sysctl."net.ipv6.conf.wlan0.use_tempaddr" = 0; # https://github.com/tailscale/tailscale/issues/2045
    kernelModules = [ "kvm-amd" "ddcci-backlight" "i2c-dev" "nct6775" ];
    kernelPackages = pkgs.linuxPackages_xanmod_lto_zen3;
    kernelParams = [
      "acpi_enforce_resources=lax"
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
    tmpOnTmpfs = true;
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
    };
    "/srv/music" = {
      device = "zroot/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "zroot/safe/pictures";
      fsType = "zfs";
    };
    "/state" = {
      device = "zroot/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    ledger.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [ ../../users/bemeurer/trusted ];
    services.easyeffects.enable = true;
  };

  location = {
    latitude = 37.861;
    longitude = -122.273;
  };

  networking = {
    hostId = "872516b8";
    hostName = "hegel";
    wireguard.enable = true;
    wireless.iwd.enable = true;
    # DHCP
    firewall.interfaces.enp6s0 = {
      allowedTCPPorts = [ 67 68 647 ];
      allowedUDPPorts = [ 67 68 647 ];
    };
  };

  nix = {
    maxJobs = 32;
    systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver3" ];
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
  };

  systemd.network.networks = {
    lan = {
      matchConfig.MACAddress = "3c:7c:3f:21:80:67";
      networkConfig = {
        Address = "192.168.2.1/24";
        DHCPServer = "yes";
        IPv6PrivacyExtensions = "kernel";
      };
      dhcpServerConfig = {
        EmitDNS = "no";
        EmitRouter = "no";
      };
      linkConfig.RequiredForOnline = "no";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "c8:e2:65:0a:7e:d1";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };

  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  swapDevices = [
    { device = "/dev/disk/by-uuid/e4103056-9ef2-47da-8403-46cf20541b15"; }
    { device = "/dev/disk/by-uuid/4b74d5bd-3e62-4077-a126-6d73ad07267f"; }
  ];

  time.timeZone = "America/Los_Angeles";

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      autoPrune.enable = true;
    };
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
