{ config, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-gpu-amd
    nixos-hardware.common-pc-laptop-ssd
    ./bluetooth.nix
    ./efi.nix
    ./sound-pipewire.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "amd-pstate" "cpufreq_conservative" "nvme" "sd_mod" "thinkpad_acpi" "thunderbolt" "usb_storage" "xhci_pci" ];
    kernelModules = [ "amd-pstate" "cpufreq_conservative" "cpufreq_ondemand" "kvm-amd" "thinkpad_acpi" ];
    kernelParams = [ "mem_sleep_default=deep" ];
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
    udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${config.systemd.package}/bin/systemctl start battery.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${config.systemd.package}/bin/systemctl stop ac.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${config.systemd.package}/bin/systemctl start ac.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${config.systemd.package}/bin/systemctl stop battery.target"
    '';
    upower = {
      enable = true;
      # FIXME: When I swap to a larger NVME, this should be "Hibernate"
      criticalPowerAction = "PowerOff";
    };
    xserver.dpi = 250;
  };

  systemd.targets = {
    ac = {
      description = "On AC power";
      unitConfig.DefaultDependencies = false;
    };
    battery = {
      description = "On battery power";
      unitConfig.DefaultDependencies = false;
    };
  };

  systemd.services = {
    cpufreq-conservative-sampling-rate = {
      after = [ "battery.target" ];
      bindsTo = [ "battery.target" ];
      wantedBy = [ "battery.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        echo "98304" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
      '';
    };
    cpufreq-ondemand-sampling-rate = {
      after = [ "ac.target" ];
      bindsTo = [ "ac.target" ];
      wantedBy = [ "ac.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        echo "98304" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
      '';
    };
    tailscaled.partOf = [ "ac.target" ];
    tailscaled.wantedBy = [ "ac.target" ];
  };
}
