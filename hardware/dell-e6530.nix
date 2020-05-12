{ pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
  ];

  boot = rec {
    initrd.availableKernelModules =
      [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  console = {
    font = "ter-v14n";
    keyMap = "uk";
    packages = with pkgs; [ terminus_font ];
  };

  hardware.brillo.enable = true;
  hardware.enableRedistributableFirmware = true;

  nix.maxJobs = 8;

  nixpkgs.system = "x86_64-linux";

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    tlp = {
      enable = true;
      extraConfig = ''
        CPU_ENERGY_PERF_POLICY_ON_AC=performance
        CPU_ENERGY_PERF_POLICY_ON_BAT=power
        CPU_MAX_PERF_ON_AC=100
        CPU_MAX_PERF_ON_BAT=50
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth wifi"
        DEVICES_TO_ENABLE_ON_AC="bluetooth wifi"

        DISK_APM_LEVEL_ON_AC="255 254"
        DISK_APM_LEVEL_ON_BAT="128 127"
        DISK_DEVICES="sda sdb"
        DISK_IOSCHED="mq-deadline bfq"

        MAX_LOST_WORK_SECS_ON_AC=15
        MAX_LOST_WORK_SECS_ON_BAT=15

        RUNTIME_PM_ON_AC=auto
        RUNTIME_PM_ON_BAT=auto

        SOUND_POWER_SAVE_ON_AC=1
        SOUND_POWER_SAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y
      '';
    };
  };
}
