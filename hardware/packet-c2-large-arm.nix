{ lib, pkgs, ... }: {
  imports = [ ./no-mitigations.nix ];

  boot = {
    initrd.availableKernelModules = [ "ahci" "pci_thunder_ecam" ];
    kernelModules = [
      "dm_multipath"
      "dm_round_robin"
      "ipmi_watchdog"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "cma=0M"
      "biosdevname=0"
      "net.ifnames=0"
      "console=ttyAMA0"
    ];
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = true;
        font = null;
        splashImage = null;
        version = 2;
        extraConfig = ''
          serial
          terminal_input serial console
          terminal_output serial console
        '';
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = lib.mkForce false;
      };
    };
  };

  environment.noXlibs = true;

  hardware.enableAllFirmware = true;

  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = lib.mkForce false;
    nameservers = [
      "147.75.207.207"
      "147.75.207.208"
    ];
  };

  nix.maxJobs = 32;

  nixpkgs.localSystem.system = "aarch64-linux";

  services.fstrim.enable = true;
}
