{ config, lib, pkgs, ... }: {
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
    networkmanager.enable = lib.mkforce false;
    useDHCP = false;
  };

  nix.maxJobs = 12;

  time.timeZone = "America/Los_Angeles";

  users.users = {
    tushar = {
      createHome = true;
      extraGroups = [ "lxd" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINH2jTl/COeeNZ6SXGsT0k/3fa1kgaSxgNGeg20s+OHV tushar@standard.ai"
      ];
      isNormalUser = true;
    };
  };
}
