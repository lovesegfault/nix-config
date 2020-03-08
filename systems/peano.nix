{ config, lib, pkgs, ... }: {
  imports = [
    ../core
    ../dev

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
    kernelPackages = pkgs.linuxPackages_5_4;
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

  users.users = {
    tushar = {
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINH2jTl/COeeNZ6SXGsT0k/3fa1kgaSxgNGeg20s+OHV tushar@standard.ai"
      ];
      isNormalUser = true;
    };
    ekleog = {
      createHome = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpQUN+FGyX80jjYX8HZv600c8jCSmhwnC/2mCsn+j/vnm5a3Tw8La7A2LocfKpocVU7cUkZNrPsXrLFOBu3jqM3VYqRlQw6ixgwonb3klpfeUu0kPg72Q6FQHMZO+yLIKwGWYDADFwxXk/KeuZK1VgAq1GGY4AdIB+PgtJ9/63rqtd0ooBX7rfKj+mMVuahS0/wxUhDufHBjv54Kk66JsUHd3gbW6EKa6bLfUQxRbJkxDycs7OvjUmUO0ndxdnqEYMaExbM+j0AFPVEc/7TW8SDL3dXtOEmIttB8nVcja5lpGyxpRJWiAxOBaosY76P5AEvfdt/JgRFdEhcr2F7YyR ekleog@llwynog"
      ];
      isNormalUser = true;
    };
    ogle = {
      createHome = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMbxQQ6asa917aD8HTavEinmIEsm6G3pZEOv7Rf33JCvvrdCW5ktOsjBm0oeRLt3aeC0QZa3nrMXixP7GCmJQWFPnAsQLlrpZnNRte5GB9X0wcUTUcvLo1kXzTBB5CRhSwdVQ9+/Ztc+LSiObPqFfsYY2pa85wYU6Q+Hu+aYSDrTvCzcL1ojEvUKnOmSWFYQ+fmYV7skKJL3Xr66zpWeCKyVtY8h7Ju3H3IWZTTl8Fyqtej63uHxqjQlMNzEjUL9Nzmev+O8+lCKvHXG+8dQBAYe3+tsIi1NKLSODSKxLpka52XIiNrgGnnr74YTZ8sp8Sd9STr3HUPr7uNK5I8DSL brandon@standard.ai"
      ];
      isNormalUser = true;
    };
  };
}
