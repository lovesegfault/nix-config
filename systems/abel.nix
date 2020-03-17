{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../hardware/intel.nix
    ../hardware/nvidia.nix
    ../hardware/zfs.nix

    ../dev
    ../dev/stcg-cachix.nix
    ../dev/stcg-cameras.nix
  ] ++ (import ../users).stream ++ (import ../users).hardware;

  boot = rec {
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "ehci_pci" "usbhid" "sd_mod" ];
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
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
  };

  nix.maxJobs = 12;

  services.xserver = {
    desktopManager.gnome3.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
      autoLogin = {
        enable = true;
        user = "clock";
      };
      wayland = false;
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
}
