{ config, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-cpu-amd-pstate
    nixos-hardware.common-gpu-amd
    nixos-hardware.common-pc-laptop-ssd
    ../../core

    ../../hardware/efi.nix
    ../../hardware/nixos-aarch64-builder

    ../../users/bemeurer

    ./roon.nix
    ./state.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" "dm-snapshot" ];
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest_lto_zen3;
    tmpOnTmpfs = true;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FDA7-5E38";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/4610a590-b6b8-4a8f-82a3-9ec7592911eb";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
      neededForBoot = true;
    };
    "/mnt/music" = {
      device = "/dev/disk/by-uuid/90bcbccf-f8a0-47a7-b542-1c1a66de20e3";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };
    "/mnt/music-opus" = {
      device = "/dev/disk/by-uuid/b6dc070f-5758-4bfe-8bfd-68b55da44ef1";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable = true;
  };

  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostId = "55a088f6";
    hostName = "jung";
    wireless.iwd.enable = true;
  };

  nix = {
    settings = {
      max-jobs = 16;
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver3" ];
    };
    gc = {
      automatic = true;
      dates = "02:30";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fwupd.enable = true;
    smartd.enable = true;
    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      devices.nozick.id = "SJH2ZVC-EUWTL4M-ZEP57G6-O5A6DYX-4AWZU7C-XF4GGED-5F6OHGC-KDHPMA6";
      folders.music = {
        devices = [ "nozick" ];
        path = "/mnt/music";
        type = "receiveonly";
      };
      group = "media";
    };
  };

  systemd.network.networks = {
    eth = {
      DHCP = "yes";
      matchConfig.MACAddress = "1c:83:41:30:ab:9b";
      dhcpV4Config.RouteMetric = 10;
      dhcpV6Config.RouteMetric = 10;
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "60:dd:8e:12:67:bd";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
    };
  };

  systemd.tmpfiles.rules = [
    "w- /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate - - - - 98304"
  ];

  swapDevices = [{ device = "/dev/disk/by-uuid/a66412e6-ff55-4053-b436-d066319ed922"; }];

  time.timeZone = "America/New_York";

  users.groups.media = {
    gid = 999;
    members = [ "bemeurer" ];
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
