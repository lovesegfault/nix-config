{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../hardware/bluetooth.nix
    ../../hardware/efi.nix
    ../../hardware/nixos-aarch64-builder

    ../../users/bemeurer

    ./state.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest_lto_zen3;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

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
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
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

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services.fwupd.enable = true;

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

  swapDevices = [{ device = "/dev/disk/by-uuid/a66412e6-ff55-4053-b436-d066319ed922"; }];

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
