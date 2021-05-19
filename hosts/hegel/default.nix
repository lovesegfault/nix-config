{ config, lib, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../dev
    ../../dev/stcg-cameras.nix
    ../../dev/stcg-gcs
    ../../dev/virt-manager.nix

    ../../hardware/bluetooth.nix
    ../../hardware/efi.nix
    ../../hardware/nixos-aarch64-builder
    ../../hardware/sound-pulse.nix
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
    kernelModules = [ "kvm-amd" "ddcci-backlight" "i2c-dev" "nct6775" ];
    kernelPackages = pkgs.linuxPackages_latest;
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

  environment.systemPackages = with pkgs; [ corectrl lutris ];

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
  };

  networking = {
    hostId = "872516b8";
    hostName = "hegel";
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  nix.maxJobs = 32;

  programs.steam.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fwupd.enable = true;
    ratbagd.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "3c:7c:3f:21:80:67";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "c8:e2:65:0a:7e:d1";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e4103056-9ef2-47da-8403-46cf20541b15"; }
    { device = "/dev/disk/by-uuid/4b74d5bd-3e62-4077-a126-6d73ad07267f"; }
  ];

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
  };
}
