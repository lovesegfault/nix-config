{ lib, pkgs, ... }: {
  imports = [
    (import ../users).stream
    ../core
    ../dev

    ../misc/intel.nix
    ../misc/nvidia.nix
    ../misc/zfs.nix

    ../misc/stcg-cachix.nix
    ../misc/stcg-cameras.nix
  ];

  boot = rec {
    extraModulePackages = [ kernelPackages.broadcom_sta ];
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "ehci_pci" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" "wl" ];
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
      device = "/dev/disk/by-uuid/336A-8D8C";
      fsType = "vfat";
    };

    "/fallback-boot-0" = {
      device = "/dev/disk/by-uuid/336E-C1BF";
      fsType = "vfat";
    };

    "/fallback-boot-1" = {
      device = "/dev/disk/by-uuid/3373-AAA2";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "peano";
    hostId = "05e167d5";
    interfaces = {
      eno1.useDHCP = false;
      enp3s0f0 = {
        useDHCP = true;
        mtu = 9000;
      };
      enp3s0f1.useDHCP = false;
      enp3s0f2.useDHCP = false;
      enp3s0f3.useDHCP = false;
    };
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
  };

  nix.maxJobs = 12;

  time.timeZone = "America/Los_Angeles";
}
