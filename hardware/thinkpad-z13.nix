{ nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-gpu-amd
    nixos-hardware.common-pc-laptop-ssd
    ./bluetooth.nix
    ./efi.nix
    ./sound-pipewire.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
    kernelModules = [ "amd-pstate" "kvm-amd" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages_latest_lto_zen3;
    tmpOnTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    opengl.enable = true;
  };

  nix.settings = {
    max-jobs = 16;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-znver3"
    ];
  };

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = [ "bluetooth" "wifi" ];
        DEVICES_TO_ENABLE_ON_AC = [ "bluetooth" "wifi" ];

        DISK_IOSCHED = [ "none" ];

        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    upower = {
      enable = true;
      # FIXME: When I swap to a larger NVME, this should be "Hibernate"
      criticalPowerAction = "PowerOff";
    };
    xserver.dpi = 250;
  };
}
