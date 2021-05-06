{ config, pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
    ./sound-pipewire.nix
  ];

  boot = rec {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = with config.boot.kernelPackages; [ bbswitch ddcci-driver ];
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "kvm-intel" "i2c_dev" "ddcci-backlight" "tcp_bbr" "kvm_intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = "options kvm_intel nested=1";
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
    nvidiaOptimus.disable = true;
  };

  nix = {
    maxJobs = 12;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" "gccarch-skylake" ];
  };

  services = {
    auto-cpufreq.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = [ "bluetooth" "wifi" ];
        DEVICES_TO_ENABLE_ON_AC = [ "bluetooth" "wifi" ];

        DISK_APM_LEVEL_ON_AC = [ "255" "255" ];
        DISK_APM_LEVEL_ON_BAT = [ "128" "1" ];

        DISK_DEVICES = [ "nvme0n1" "sda" ];
        DISK_IOSCHED = [ "none" "bfq" ];

        MAX_LOST_WORK_SECS_ON_AC = 15;
        MAX_LOST_WORK_SECS_ON_BAT = 15;

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RUNTIME_PM_DRIVER_BLACKLIST = [ ];

        SOUND_POWER_SAVE_ON_AC = "1";
        SOUND_POWER_SAVE_ON_BAT = "1";
        SOUND_POWER_SAVE_CONTROLLER = "Y";

        #                 sd-card     yubikey     wacom
        USB_WHITELIST = [ "0bda:0328" "1050:0407" "056a:5193" ];
      };
    };

    xserver.dpi = 96;
  };

  sound.extraConfig = ''
    options snd-hda-intel model=generic
  '';

  systemd.services.auto-cpufreq.wantedBy = [ "multi-user.target" ];
}
