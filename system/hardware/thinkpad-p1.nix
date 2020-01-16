{ config, pkgs, ... }: {
  imports = [
    ../modules/efi.nix
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
    ../modules/thunderbolt.nix
    ../modules/tlp.nix
  ];

  boot = rec {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    extraModulePackages = with kernelPackages; [ acpi_call tp_smapi ];
    kernelModules = [ "acpi_call" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  nix.maxJobs = 12;

  nixpkgs.config.allowUnfree = true;

  programs.light.enable = true;

  services = {
    fprintd.package = pkgs.fprintd-thinkpad;
    fstrim.enable = true;
    undervolt = {
      enable = true;
      coreOffset = "-70";
      temp = "95";
    };
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

  powerManagement.cpuFreqGovernor = "powersave";

  users.users.bemeurer.extraGroups = [ "camera" ];
}
