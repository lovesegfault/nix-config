{ nixos-hardware, pkgs, ... }: {
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop-ssd

    ./bluetooth.nix
    ./efi.nix
    ./sound.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "thinkpad_acpi" "thunderbolt" "xhci_pci" ];
    blacklistedKernelModules = [ "sp5100_tco" ];
    kernelModules = [ "cpufreq_conservative" "cpufreq_ondemand" "kvm-amd" "thinkpad_acpi" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "nowatchdog" ];
    tmp.useTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [ iw ];
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    opengl.enable = true;
  };

  nix.settings.system-features = [
    "benchmark"
    "nixos-test"
    "big-parallel"
    "kvm"
    "gccarch-znver3"
  ];

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";

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
      criticalPowerAction = "Hibernate";
    };
    xserver.dpi = 250;
  };

  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
  '';

  systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];
}
