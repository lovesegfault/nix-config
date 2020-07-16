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
    initrd.availableKernelModules = [ "FIXME" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.persistence."/state" = {
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixus-secrets"
    ] ++ [
      "/home/bemeurer/.gnupg"
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
      device = "/dev/disk/by-uuid/FIXME";
      fsType = "vfat";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/srv/music" = {
      device = "rpool/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "rpool/safe/pictures";
      fsType = "zfs";
    };
    "/state" = {
      device = "rpool/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [ (import ../nix).impermanence-home ];
    home.persistence."/state/home/bemeurer" = {
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
    hostName = "spinoza";
    hostId = "FIXME";
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
    links.FIXME = {
      linkConfig.MTUBytes = "9000";
      matchConfig.MACAddress = "FIXME";
    };
    networks = {
      lan = {
        DHCP = "ipv4";
        linkConfig = {
          MTUBytes = "9000";
          RequiredForOnline = "no";
        };
        matchConfig.MACAddress = "FIXME";
      };
      wifi = {
        DHCP = "yes";
        matchConfig.MACAddress = "FIXME";
      };
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/FIXME"; }];

  time.timeZone = "America/Los_Angeles";
}
