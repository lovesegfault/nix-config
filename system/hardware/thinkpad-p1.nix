{ pkgs, ... }: {
  imports = [
    ../modules/efi.nix
    ../modules/bluetooth.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
    ../modules/tlp.nix
    ../pkgs/linux-5.5-fixes.nix
  ];

  boot = rec {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    extraModulePackages = with kernelPackages; [ acpi_call ];
    kernelModules = [ "acpi_call" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = with pkgs; [ nouveau-gr-fix nouveau-pci-fix ];
    kernelParams = [ "log_buf_len=5M" "psmouse.synaptics_intertouch=1" ];
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
    xserver.libinput = {
      accelProfile = "flat";
      accelSpeed = "0.7";
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
