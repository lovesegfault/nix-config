{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-intel-cpu-only

    ../../core

    ../../hardware/no-mitigations.nix
    ../../hardware/zfs.nix

    ../../users/bemeurer

    ./deluge.nix
    ./grafana.nix
    ./nextcloud.nix
    ./state.nix
    ./unbound.nix
    ./vouch.nix
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
    kernel.sysctl = {
      "net.core.default_qdisc" = "cake";
      "net.core.optmem_max" = 65536;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.somaxconn" = 8192;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.log_martians" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.ip_local_port_range" = "16384 65535";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      "net.ipv4.tcp_max_tw_buckets" = 2000000;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.udp_rmem_min" = 8192;
      "net.ipv4.udp_wmem_min" = 8192;
      "net.netfilter.nf_conntrack_generic_timeout" = 60;
      "net.netfilter.nf_conntrack_max" = 1048576;
      "net.netfilter.nf_conntrack_tcp_timeout_established" = 600;
      "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = 1;
    };
    kernelModules = [ "kvm-intel" "tls" "tcp_bbr" ];
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
          # { devices = [ "/dev/disk/by-uuid/3C1E-F6BC" ]; path = "/boot-1"; }
          { devices = [ "/dev/disk/by-uuid/3BF7-22B8" ]; path = "/boot-2"; }
          # { devices = [ "/dev/disk/by-uuid/3BCE-B683" ]; path = "/boot-3"; }
        ];
      };
    };
    tmpOnTmpfs = true;
    zfs.requestEncryptionCredentials = [ ];
  };

  environment.systemPackages = with pkgs; [
    smartmontools
  ];

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

  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostName = "nozick";
    hostId = "d0d7d1dc";
    firewall = {
      allowedTCPPorts = [ 443 32400 ];
      allowedUDPPorts = [ 32400 ];
      logRefusedConnections = false;
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
    nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      package = pkgs.nginxMainline;
      resolver.addresses = [ "127.0.0.1:53" ];
      resolver.ipv6 = false;
      virtualHosts = {
        "stash.meurer.org" = {
          useACMEHost = "stash.meurer.org";
          forceSSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9999";
            proxyWebsockets = true;
          };
        };
      };
    };
    openssh.extraConfig = ''
      MaxStartups 40:30:120
    '';
    plex.enable = true;
    smartd.enable = true;
    sshguard.enable = true;
    syncthing = {
      enable = true;
      group = "media";
      guiAddress = "0.0.0.0:8384";
      devices = {
        jung.id = "GXCBSO2-RQAR3CC-ACW6JWB-IAZHQZO-XZWSYKL-SYB2GNS-T4R5QO2-Q76BXAV";
      };
      folders.music = {
        devices = [ "jung" ];
        path = "/mnt/music";
        type = "sendonly";
      };
    };
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

  systemd.network.networks.eth = {
    matchConfig.MACAddress = "90:1b:0e:db:06:2f";
    DHCP = "yes";
  };

  time.timeZone = "Etc/UTC";

  users = {
    users.root.passwordFile = config.age.secrets.rootPassword.path;
    groups = {
      acme.members = [ "nginx" ];
      media.members = [ "bemeurer" "plex" ];
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
