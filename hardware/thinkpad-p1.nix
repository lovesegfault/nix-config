{ pkgs, ... }: {
  imports = [
    ../misc/efi.nix
    ../misc/bluetooth.nix
    ../misc/fwupd.nix
    ../misc/intel.nix
    ../misc/tlp.nix
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

  programs.light.enable = true;

  services = {
    fstrim.enable = true;
    hardware.bolt.enable = true;
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

  # powerManagement.cpuFreqGovernor = "powersave";

  users.users.bemeurer.extraGroups = [ "camera" ];
}
