{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-intel-cpu-only

    ../../core

    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix
    ../../hardware/zfs.nix

    ../../services/grafana.nix
    ../../services/nginx.nix
    ../../services/oauth2.nix
    ../../services/prometheus.nix
    ../../services/syncthing.nix
    ../../services/unbound.nix

    ../../users/bemeurer

    ./nextcloud.nix
    ./rtorrent.nix
    ./state.nix
  ];

  age.secrets = {
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
      allowedTCPPorts = [ 32400 ];
      allowedUDPPorts = [ 32400 ];
      logRefusedConnections = false;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  security = {
    acme.certs."stash.nozick.meurer.org" = { };
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
      resolver.addresses = [ "127.0.0.1:53" ];
      resolver.ipv6 = false;
      virtualHosts = {
        "stash.nozick.meurer.org" = {
          useACMEHost = "stash.nozick.meurer.org";
          kTLS = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9999";
            proxyWebsockets = true;
          };
        };
      };
    };
    oauth2_proxy.nginx.virtualHosts = [ "stash.nozick.meurer.org" ];
    openssh.extraConfig = ''
      MaxStartups 40:30:120
    '';
    plex.enable = true;
    smartd.enable = true;
    sshguard.enable = true;
    syncthing.folders = {
      music = {
        devices = [ "bohr" "jung" ];
        path = "/mnt/music";
        type = "sendonly";
      };
      opus = {
        devices = [ "jung" ];
        path = "/mnt/music-opus";
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
    groups.media.members = [ "bemeurer" "plex" config.services.syncthing.user ];
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
