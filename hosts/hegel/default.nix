{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate

    ../../core

    ../../hardware/efi.nix
    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix
    ../../hardware/secureboot.nix

    ../../users/bemeurer

    ./disko.nix
    ./state.nix
    # ./kexec
  ];

  age.secrets = {
    rootPassword.file = ./password.age;
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "sd_mod"
      ];
      systemd = {
        enable = true;
        services.rollback = {
          description = "Rollback root filesystem to a pristine state on boot";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs_unstable ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@blank && echo "  >> >> rollback complete << <<"
          '';
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    lanzaboote.pkiBundle = lib.mkForce "/var/lib/sbctl";
    tmp.useTmpfs = true;
    zfs.package = pkgs.zfs_unstable;
  };

  environment.systemPackages = with pkgs; [
    dig
    smartmontools
    zfs_unstable
  ];

  hardware.enableRedistributableFirmware = true;

  home-manager.verbose = true;
  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostId = "65618eec";
    hostName = "hegel";
    firewall = {
      # allowedTCPPorts = [ 32400 ];
      # allowedUDPPorts = [ 32400 ];
    };
    nftables.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      max-substitution-jobs = 32;
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-znver5"
      ];
    };
  };

  security = {
    pam.loginLimits = [
      {
        domain = "*";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "-";
        item = "nproc";
        value = "unlimited";
      }
    ];
  };

  services = {
    fwupd.enable = true;
    smartd.enable = true;
    zfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
      trim = {
        enable = true;
        interval = "weekly";
      };
    };
  };

  systemd.network.networks = {
    eth0 = {
      DHCP = "yes";
      matchConfig.MACAddress = "bc:fc:e7:eb:17:d4";
      dhcpV4Config.RouteMetric = 10;
      dhcpV6Config.RouteMetric = 10;
    };
  };

  time.timeZone = "America/New_York";

  users = {
    users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
  };

  virtualisation = {
    containers = {
      containersConf.settings.containers.annotations = [ "run.oci.keep_original_groups=1" ];
      storage.settings.storage = {
        driver = "zfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
