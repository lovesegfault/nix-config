{ config, nixos-hardware, pkgs, ... }: {
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-pc-laptop-ssd

    ../../core

    ../../hardware/efi.nix
    ../../hardware/fast-networking.nix
    ../../hardware/zfs.nix

    ../../services/blocky.nix
    ../../services/grafana.nix
    ../../services/nginx.nix
    ../../services/oauth2.nix
    ../../services/prometheus.nix
    ../../services/syncthing.nix

    ../../users/bemeurer

    ./state.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    tmp.useTmpfs = true;
    zfs = {
      extraPools = [ "tank" ];
      requestEncryptionCredentials = false;
    };
  };

  console = {
    font = "ter-v14n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    nameserver 100.100.100.100
    nameserver 1.1.1.1
    options edns0 trust-ad
    search local meurer.org.beta.tailscale.net
  '';

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
    pulseaudio.enable = false;
  };

  networking = {
    hostId = "80f4ef89";
    hostName = "fourier";
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    blocky.settings = {
      conditional.mapping = {
        ".local" = "10.0.0.1";
        "." = "10.0.0.1";
      };
      clientLookup.upstream = "10.0.0.1";
    };
    chrony = {
      enable = true;
      servers = [ "time.nist.gov" "time.cloudflare.com" "time.google.com" "tick.usnogps.navy.mil" ];
      extraConfig = ''
        allow 10.0.0.0/24
      '';
    };
    nginx.resolver.addresses = [ "127.0.0.1:5335" ];
    fstrim.enable = true;
    fwupd.enable = true;
    smartd.enable = true;
    syncthing.settings.folders = {
      music = {
        devices = [ "bohr" "jung" "nozick" ];
        path = "/srv/music";
        type = "receiveonly";
      };
      opus = {
        devices = [ "jung" "nozick" ];
        path = "/srv/opus";
        type = "receiveonly";
      };
    };
    unbound.settings.server.access-control = [ "10.0.0.0/24 allow" ];
    zfs.autoScrub.pools = [ "tank" ];
    zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  system.activationScripts.setIOScheduler = ''
    disks=(sda sdb sdc sdd nvme0n1)
    for disk in "''${disks[@]}"; do
      echo "none" > /sys/block/$disk/queue/scheduler
    done
  '';

  systemd.network.networks.eth = {
    matchConfig.MACAddress = "18:c0:4d:31:0c:5f";
    DHCP = "yes";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/6075a47d-006a-4dbb-9f86-671955132e2f"; }];

  time.timeZone = "America/New_York";

  users.groups.media = {
    gid = 999;
    members = [ "bemeurer" config.services.syncthing.user ];
  };

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;

  virtualisation = {
    containers.containersConf.settings.engine.helper_binaries_dir = [ "${pkgs.netavark}/bin" ];
    oci-containers.backend = "podman";
    podman.enable = true;
  };
}
