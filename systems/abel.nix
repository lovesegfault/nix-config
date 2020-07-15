{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../hardware/intel.nix
    ../hardware/nvidia.nix
    ../hardware/zfs.nix

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-cameras.nix

    ../users/andi.nix
    ../users/bemeurer
    ../users/cloud.nix
    ../users/ekleog.nix
    ../users/nagisa.nix
    ../users/ogle.nix
  ];

  boot = rec {
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "ehci_pci" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages;
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
    useNetworkd = lib.mkForce false;
    interfaces.enp4s0f0 = {
      useDHCP = true;
      mtu = 9000;
    };
  };

  nix.maxJobs = 12;

  services.sshguard.enable = lib.mkForce false;
  services.xserver = {
    desktopManager.gnome3.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "clock";
      };
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = false;
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  users.users.clock = {
    createHome = true;
    isNormalUser = true;
    hashedPassword =
      "$6$O3fiKzeie2Woy$DsVuPscv2q838lCt.NP9J0bWo0FrxGtHsJtVr5qp/EpbLvnD7B6ixbosWer2pf5YPao1yyf29ICbKTF8PrBe./";
    packages = [ pkgs.chromium ];
  };

  virtualisation.docker.enable = true;
}
