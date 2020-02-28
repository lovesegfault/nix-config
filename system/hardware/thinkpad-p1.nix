{ config, lib, pkgs, ... }: {
  imports = [
    ../modules/efi.nix
    ../modules/bluetooth.nix
    # ../modules/bumblebee.nix
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

  hardware.enableAllFirmware = true;

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  nix.maxJobs = 12;

  nixpkgs.config.allowUnfree = true;

  programs.light.enable = true;

  services = {
    fstrim.enable = true;
    hardware.bolt.enable = true;
    throttled.enable = true;
    xserver = {
      libinput = {
        accelProfile = "flat";
        accelSpeed = "0.7";
      };
      windowManager.i3.extraSessionCommands = ''
        export GDK_SCALE=2
        export GDK_DPI_SCALE=0.5
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
      '';
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  users.users.bemeurer.extraGroups = [ "camera" ];
}
