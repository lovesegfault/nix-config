{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-cpu-amd-pstate
    nixos-hardware.common-gpu-amd
    nixos-hardware.common-pc-laptop-ssd
    ../../core

    ../../hardware/efi.nix

    ../../users/bemeurer

    ./state.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
    extraModprobeConfig = ''
      options snd_usb_audio lowlatency=0
    '';
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BA13-FF11";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/97954bac-24aa-449e-aa96-c6d3c88fbce3";
      fsType = "ext4";
      neededForBoot = true;
    };
    "/srv/music" = {
      device = "/dev/disk/by-uuid/91b15b49-9247-4d80-9799-a786a1a68920";
      fsType = "btrfs";
      options = [ "subvol=music" "noatime" ];
    };
    "/srv/roon" = {
      device = "/dev/disk/by-uuid/91b15b49-9247-4d80-9799-a786a1a68920";
      fsType = "btrfs";
      options = [ "subvol=roon" "noatime" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  networking = {
    hostId = "40f886cd";
    hostName = "bohr";
    wireless.iwd.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/srv/music" "/srv/roon" ];
      interval = "weekly";
    };
    fstrim.enable = true;
    fwupd.enable = true;
    roon-bridge = {
      enable = true;
      openFirewall = true;
    };
    smartd.enable = true;
  };

  systemd.services.roon-bridge.serviceConfig.ExecStart = lib.mkForce "${pkgs.roon-bridge}/bin/RoonBridge";

  systemd.network.networks = {
    eth = {
      DHCP = "yes";
      matchConfig.MACAddress = "04:42:1a:0d:a3:40";
      dhcpV4Config.RouteMetric = 10;
      dhcpV6Config.RouteMetric = 10;
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "38:fc:98:17:78:39";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/66ee7c01-6753-41ca-8987-2eecac3bb653"; }];

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
