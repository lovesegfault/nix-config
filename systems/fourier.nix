{ lib, pkgs, ... }: {
  imports = [
    (import ../nix).impermanence-sys
    ../core

    ../dev

    ../hardware/efi.nix
    ../hardware/nouveau.nix
    ../hardware/zfs.nix

    ../users/bemeurer
  ];

  boot = rec {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.persistence."/nix/state" = {
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixus-secrets"
    ] ++ [
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/nvim"
      "/home/bemeurer/.local/share/zsh"
      "/home/bemeurer/.ssh"
      "/home/bemeurer/src"
      "/home/bemeurer/tmp"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E954-11BC";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/b192a21f-08ae-4ce9-ac41-053854fc52c9";
      fsType = "xfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [ (import ../nix).impermanence-home ];
    home.persistence."/nix/state/home/bemeurer" = {
      files = [
        ".config/cachix/cachix.dhall"
        ".gist"
        ".gist-vim"
        ".newsboat/cache.db"
        ".newsboat/history.search"
      ];
    };
  };

  networking = {
    hostName = "fourier";
    hostId = "80f4ef89";
    wireless.iwd.enable = true;
  };

  nix = {
    maxJobs = 16;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    roon-server = {
      enable = true;
      openFirewall = true;
    };
  };

  systemd.network = {
    networks = {
      # lan = {
      #   DHCP = "ipv4";
      #   linkConfig = {
      #     MTUBytes = "9000";
      #     RequiredForOnline = "no";
      #   };
      #   matchConfig.MACAddress = "FIXME";
      # };
      wifi = {
        DHCP = "yes";
        matchConfig.MACAddress = "a8:7e:ea:cb:96:cf";
      };
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/6075a47d-006a-4dbb-9f86-671955132e2f"; }];

  time.timeZone = "America/Los_Angeles";
}
