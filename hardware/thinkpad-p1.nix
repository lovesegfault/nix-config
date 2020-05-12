{ pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
    ./nouveau.nix
  ];

  boot = rec {
    extraModprobeConfig = ''
      options thinkpad_acpi experimental=1
    '';
    extraModulePackages = with kernelPackages; [ ddcci-driver ];
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" "i2c_dev" "ddcci-backlight" ];
    kernelPackages = pkgs.linuxPackages;
    kernelPatches = [
      {
        # FIXME: Remove this when kernel 5.8 is out
        name = "thinkpad-dual-fan-ctrl";
        patch = (
          pkgs.fetchpatch {
            url = "http://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git/patch/14232c6e788cb1f7b96dbd08b077f90923324b24?hp=4a65ed6562bcfa58fe0c2ca5855c45268f40d365";
            sha256 = "1bp7hg4ppwiyp0bvhijhqr2gcz79g1lv22fyq3bb8rbcwziszxa6";
          }
        );
      }
    ];
    kernelParams = [
      # more dmesg
      "log_buf_len=5M"
      # i don't know, the kernle complains
      "psmouse.synaptics_intertouch=1"
      # force iwlwifi power saving on
      "iwlwifi.power_save=Y"
      "iwldvm.force_cam=N"
    ];
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  nix.maxJobs = 12;

  nixpkgs.system = "x86_64-linux";

  programs.light.enable = true;

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    thinkfan = {
      enable = true;
      smartSupport = true;
    };
    throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        Enabled: True
        Sysfs_Power_Path: /sys/class/power_supply/AC/online

        [BATTERY]
        Update_Rate_s: 120
        # Max package power for time window #1
        PL1_Tdp_W: 29
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 90
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: False

        [AC]
        Update_Rate_s: 120
        # Max package power for time window #1
        PL1_Tdp_W: 44
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 95
        # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
        HWP_Mode: False
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: False
      '';
    };
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
        DISK_APM_LEVEL_ON_BAT="128 1"
        DISK_DEVICES="nvme0n1 sda"
        DISK_IOSCHED="none bfq"

        MAX_LOST_WORK_SECS_ON_AC=15
        MAX_LOST_WORK_SECS_ON_BAT=15

        RUNTIME_PM_ON_AC=auto
        RUNTIME_PM_ON_BAT=auto
        RUNTIME_PM_DRIVER_BLACKLIST="amdgpu nouveau nvidia radeon"

        SOUND_POWER_SAVE_ON_AC=1
        SOUND_POWER_SAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y

        #              sd-card   yubikey   wacom
        USB_WHITELIST="0bda:0328 1050:0407 056a:5193"
      '';
    };

    # block my dumb sd-card reader that chugs power from coming on
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0328", ATTR{authorized}="0"
    '';
    xserver.dpi = 96;
  };
}
