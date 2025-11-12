{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:
{
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd

    ../../core

    ../../hardware/efi.nix
    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix
    ../../hardware/nvidia.nix
    ../../hardware/secureboot.nix

    ../../services/blocky.nix
    ../../services/grafana.nix
    ../../services/nginx.nix
    ../../services/oauth2.nix
    ../../services/prometheus.nix

    ../../users/bemeurer

    ./boot.nix
    ./disko.nix
    ./state.nix
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    lanzaboote.pkiBundle = lib.mkForce "/var/lib/sbctl";
    tmp.useTmpfs = true;
    zfs.package = pkgs.zfs_unstable;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [
    dig
    smartmontools
    zfs_unstable
  ];

  hardware.enableRedistributableFirmware = true;

  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostId = "65618eec";
    hostName = "hegel";
    nftables.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      download-buffer-size = 268435456; # 256MiB
      max-jobs = lib.mkForce 12;
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

  powerManagement.cpuFreqGovernor = "performance";

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
    chrony = {
      enable = true;
      servers = [
        "time.nist.gov"
        "time.cloudflare.com"
        "time.google.com"
        "tick.usnogps.navy.mil"
      ];
      extraConfig = ''
        allow 10.0.0.0/24
      '';
    };
    nginx.resolver.addresses = [ "127.0.0.1:5335" ];
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
    unbound.settings.server.access-control = [ "10.0.0.0/24 allow" ];
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

  users.groups.media = {
    gid = 999;
    members = [
      "bemeurer"
      config.services.syncthing.user
    ];
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;

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
