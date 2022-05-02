{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-intel-cpu-only

    ../../core

    ../../hardware/zfs.nix

    ../../users/bemeurer

    ./state.nix
    ./unbound.nix
  ];

  age.secrets = {
    acme.file = ./acme.age;
    agent.file = ./agent.age;
    ddns.file = ./ddns.age;
    rootPassword.file = ./password.age;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "sd_mod" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/local/root@blank
      '';
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest_lto_skylake;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        version = 2;
        mirroredBoots = [
          { devices = [ "/dev/disk/by-uuid/3C46-FB41" ]; path = "/boot"; }
          { devices = [ "/dev/disk/by-uuid/3C1E-F6BC" ]; path = "/boot-1"; }
          { devices = [ "/dev/disk/by-uuid/3BF7-22B8" ]; path = "/boot-2"; }
          { devices = [ "/dev/disk/by-uuid/3BCE-B683" ]; path = "/boot-3"; }
        ];
      };
    };
    tmpOnTmpfs = true;
    zfs.requestEncryptionCredentials = [ ];
  };

  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3C46-FB41";
      fsType = "vfat";
    };
    "/boot-1" = {
      device = "/dev/disk/by-uuid/3C1E-F6BC";
      fsType = "vfat";
    };
    "/boot-2" = {
      device = "/dev/disk/by-uuid/3BF7-22B8";
      fsType = "vfat";
    };
    "/boot-3" = {
      device = "/dev/disk/by-uuid/3BCE-B683";
      fsType = "vfat";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/nix/state" = {
      device = "rpool/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "nozick";
    hostId = "d0d7d1dc";
    firewall = {
      allowedTCPPorts = [ 49330 ];
      allowedUDPPorts = [ 49330 ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      max-jobs = 8;
      system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "bernardo@meurer.org";
        credentialsFile = config.age.secrets.acme.path;
        dnsProvider = "cloudflare";
      };
      certs = {
        "deluge.meurer.org" = { };
        "grafana.meurer.org" = { };
        "plex.meurer.org" = { };
        "stash.meurer.org" = { };
      };
    };
    pam.loginLimits = [
      { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
      { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
      { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
    ];
  };

  services = {
    chrony = {
      enable = true;
      servers = [ "time.nist.gov" "time.cloudflare.com" "time.google.com" "tick.usnogps.navy.mil" ];
    };
    deluge = {
      enable = true;
      openFilesLimit = "1048576";
      web.enable = true;
    };
    grafana = {
      enable = true;
      addr = "0.0.0.0";
      extraOptions.DASHBOARDS_MIN_REFRESH_INTERVAL = "1s";
    };
    nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true;
      virtualHosts = {
        "deluge.meurer.org" = {
          useACMEHost = "deluge.meurer.org";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:8112";
          };
        };
        "grafana.meurer.org" = {
          useACMEHost = "grafana.meurer.org";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:3000";
          };
        };
        "plex.meurer.org" = {
          useACMEHost = "plex.meurer.org";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:32400";
          };
        };
        "stash.meurer.org" = {
          useACMEHost = "stash.meurer.org";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:9999";
          };
        };
      };
    };
    plex.enable = true;
    prometheus = {
      enable = true;
      extraFlags = [ "--storage.tsdb.retention.time=90d" ];
      scrapeConfigs = [
        {
          job_name = "node";
          scrape_interval = "10s";
          static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
        }
        {
          job_name = "unbound";
          scrape_interval = "30s";
          static_configs = [{ targets = [ "127.0.0.1:9167" ]; }];
        }
        {
          job_name = "prometheus";
          scrape_interval = "30s";
          static_configs = [{ targets = [ "127.0.0.1:9090" ]; }];
        }
      ];
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" "pressure" ];
        };
        unbound = {
          enable = true;
          controlInterface = "/run/unbound/unbound.ctl";
          user = "unbound";
        };
      };
    };
    smartd.enable = true;
    sshguard.enable = true;
    zfs = {
      autoScrub.pools = [ "rpool" ];
      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/27d72c76-1e49-4ba0-8764-6213f26ee91a"; }
    { device = "/dev/disk/by-uuid/37154e3e-28b6-4894-86b2-86c96f367f64"; }
    { device = "/dev/disk/by-uuid/c75a325f-fc5d-4288-a138-8aaafe87ca5f"; }
    { device = "/dev/disk/by-uuid/3cbbd63d-33e7-4eea-85d8-07e665367530"; }
  ];

  systemd.network = {
    networks.eth = {
      matchConfig.MACAddress = "90:1b:0e:db:06:2f";
      DHCP = "yes";
    };
    wait-online.anyInterface = true;
  };

  time.timeZone = "Etc/UTC";

  users = {
    users.root.passwordFile = config.age.secrets.rootPassword.path;
    groups = {
      acme.members = [ "nginx" ];
      media.members = [ "bemeurer" "deluge" "plex" ];
    };
  };

  virtualisation = {
    containers.storage.settings.storage.driver = "zfs";
    oci-containers = {
      backend = "podman";
      containers.ddns = {
        autoStart = true;
        image = "timothyjmiller/cloudflare-ddns:latest";
        volumes = [
          "${config.age.secrets.ddns.path}:/config.json"
        ];
        extraOptions = [ "--network=host" ];
      };
    };
    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
