{ pkgs, ... }: {
  imports = [
    ../misc/efi.nix
    ../misc/bluetooth.nix
    ../misc/fwupd.nix
    ../misc/intel.nix
  ];

  boot = rec {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    extraModulePackages = with kernelPackages; [ acpi_call ];
    kernelModules = [ "acpi_call" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [
      {
        name = "nouveau-gr-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/0a4d0a9f2ab29b4765ee819753fbbcbc2aa7da97.patch";
            sha256 = "1k4lf1cnydckjn2fqdqiizba3rzjg27xa97xjaif4ss5m7mh4ckn";
          }
        );
      }
      {
        name = "nouveau-runpm-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/1e6cef9e6c4d17f6d893dae3cd7d442d8574b4b5.patch";
            sha256 = "103myhwmi55f7vaxk9yqrl4diql6z32am5mzd6kvk89j9m02h528";
          }
        );
      }
      {
        name = "xfs-2038-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://lkml.org/lkml/diff/2019/12/26/349/1";
            sha256 = "1jzxncv97w3ns60nk91b9b0a11bp1axng370qhv4fs7ik01yfsa4";
          }
        );
      }
    ];
    kernelParams = [
      "log_buf_len=5M"
      "psmouse.synaptics_intertouch=1"
      # "nouveau.runpm=0"
      # "nouveau.noaccel=1"
      # "nouveau.nofbaccel=1"
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
    hardware.bolt.enable = true;
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
        DISK_IOSCHED="mq-deadline bfq"

        MAX_LOST_WORK_SECS_ON_AC=15
        MAX_LOST_WORK_SECS_ON_BAT=15

        RUNTIME_PM_ON_AC=auto
        RUNTIME_PM_ON_BAT=auto
        RUNTIME_PM_DRIVER_BLACKLIST="amdgpu nouveau nvidia radeon"

        SOUND_POWER_SAVE_ON_AC=1
        SOUND_POWER_SAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y

        USB_WHITELIST="1050:0407 056a:5193"
      '';
    };
    xserver = {
      dpi = 96;
      libinput = {
        accelProfile = "adaptive";
        accelSpeed = "0.7";
      };
    };
  };

  systemd.tmpfiles.rules = [
    # MSR
    # PL1
    "w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw - - - - 44000000"
    "w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_time_window_us - - - - 28000000"
    # PL2
    "w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw - - - - 44000000"
    "w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_time_window_us - - - - 2440"
    # MCHBAR
    # PL1
    "w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw - - - - 44000000"
    "w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_time_window_us - - - - 28000000"
    # PL2
    "w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_power_limit_uw - - - - 44000000"
    "w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_time_window_us - - - - 2440"
  ];
}
