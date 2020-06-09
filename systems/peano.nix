{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../hardware/intel.nix
    ../hardware/nvidia.nix
    ../hardware/zfs.nix

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-cameras.nix
  ] ++ (import ../users).stream ++ (import ../users).hardware;

  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" ];
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
    useNetworkd = lib.mkForce false;
    interfaces.enp3s0f0 = {
      useDHCP = true;
      mtu = 9000;
    };
  };

  nix.maxJobs = 12;

  services.sshguard.enable = lib.mkForce false;

  time.timeZone = "America/Los_Angeles";

  virtualisation.docker.enable = true;
}
