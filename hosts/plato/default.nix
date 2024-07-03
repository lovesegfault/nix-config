{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate

    ../../core

    ../../hardware/efi.nix
    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix
    ../../hardware/zfs.nix

    ../../services/nginx.nix
    ../../services/oauth2.nix
    ../../services/unbound.nix

    ../../users/bemeurer

    ./disko.nix
    ./state.nix
  ];

  age.secrets = {
    rootPassword.file = ./password.age;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sd_mod" ];
      systemd = {
        enable = true;
        services.rollback = {
          description = "Rollback root filesystem to a pristine state on boot";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@blank && echo "  >> >> rollback complete << <<"
          '';
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    tmp.useTmpfs = true;
    zfs.requestEncryptionCredentials = lib.mkForce [ ];
  };

  environment.systemPackages = with pkgs; [
    dig
    smartmontools
  ];

  hardware.enableRedistributableFirmware = true;

  home-manager.verbose = true;
  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostId = "e4c9bd10";
    hostName = "plato";
    firewall = {
      # allowedTCPPorts = [ 32400 ];
      # allowedUDPPorts = [ 32400 ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      max-substitution-jobs = 96;
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-znver3"
      ];
    };
  };

  security = {
    acme.certs."stash.${config.networking.hostName}.meurer.org" = { };
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
        "stash.${config.networking.hostName}.meurer.org" = {
          useACMEHost = "stash.${config.networking.hostName}.meurer.org";
          kTLS = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9999";
            proxyWebsockets = true;
          };
        };
      };
    };
    fwupd.enable = true;
    oauth2-proxy.nginx.virtualHosts."stash.${config.networking.hostName}.meurer.org" = { };
    smartd.enable = true;
    sshguard = {
      enable = true;
      attack_threshold = 20;
      blocktime = 180;
      detection_time = 3600;
      blacklist_threshold = 100;

    };
    zfs = {
      autoScrub.pools = [ "zroot" "zdata" ];
      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd.network.networks = {
    eth0 = {
      matchConfig.MACAddress = "58:11:22:c4:49:a9";
      DHCP = "yes";
    };
    eth1 = {
      matchConfig.MACAddress = "6c:b3:11:08:50:54";
      DHCP = "yes";
    };
  };

  time.timeZone = "Etc/UTC";

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
