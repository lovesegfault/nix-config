{ config, pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
    ./sound-pipewire.nix
  ];

  boot = rec {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ddcci-driver ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "nouveau" ];
    };
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "acpi_call" "i2c_dev" "ddcci-backlight" "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages_latest_lto_skylake;
    kernelParams = [ "acpi_mask_gpe=0x69" ];
    tmpOnTmpfs = true;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    nvidia = {
      nvidiaSettings = false;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
      };
    };
  };

  nix.settings = {
    max-jobs = 12;
    system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" "gccarch-skylake" ];
  };

  powerManagement.cpuFreqGovernor = "powersave";

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = [ "bluetooth" "wifi" ];
        DEVICES_TO_ENABLE_ON_AC = [ "bluetooth" "wifi" ];

        DISK_IOSCHED = [ "none" "mq-deadline" ];

        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 80;

        #                 sd-card     yubikey     wacom
        USB_ALLOWLIST = [ "0bda:0328" "1050:0407" "056a:5193" ];
      };
    };
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };
    xserver.dpi = 96;
  };

  # specialisation.performance.configuration = {
  #   imports = [ ./nvidia.nix ];
  #   system.nixos.tags = [ "performance" ];
  #   boot.initrd.kernelModules = lib.mkForce (lib.remove "nouveau" config.boot.initrd.kernelModules);
  #   environment.systemPackages = with pkgs; [ nvidia-offload ];
  #   home-manager.users.bemeurer.wayland.windowManager.sway.extraSessionCommands = ''
  #     export GBM_BACKEND=nvidia-drm
  #     export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   '';
  # };

  sound.extraConfig = ''
    options snd-hda-intel model=generic
  '';
}
