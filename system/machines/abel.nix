{ config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../combo/core.nix
    ../combo/dev.nix

    ../modules/intel.nix
    ../modules/nvidia.nix
    ../modules/zfs.nix

    ../modules/openssh.nix
    ../modules/stcg-cachix.nix
    ../modules/stcg-cameras.nix
  ];

  boot = rec {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "usbhid"
      "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    supportedFilesystems = [ "zfs" ];
    tmpOnTmpfs = true;
  };

  console.earlySetup = true;

  fileSystems = {
    "/" = {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AA99-AC5F";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "abel";
    hostId = "9fc799ef";
    useDHCP = false;
    interfaces = {
      eno1.useDHCP = false;
      enp4s0f0 = {
        useDHCP = true;
        mtu = 9000;
      };
      enp4s0f1.useDHCP = false;
      enp4s0f2.useDHCP = false;
      enp4s0f3.useDHCP = false;
    };
  };

  nix.maxJobs = 12;

  time.timeZone = "America/Los_Angeles";
}
