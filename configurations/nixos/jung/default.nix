# NixOS configuration for jung
{
  flake,
  config,
  pkgs,
  utils,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # Hardware modules from nixos-hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-bemeurer
    self.nixosModules.hardware-efi
    self.nixosModules.hardware-fast-networking
    self.nixosModules.pam-limits
    self.nixosModules.services-grafana
    self.nixosModules.services-nginx
    self.nixosModules.services-oauth2
    self.nixosModules.services-prometheus
    self.nixosModules.services-syncthing

    # Host-specific files
    ./roon.nix
    ./state.nix
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer.imports = [ self.homeModules.music ];

  # SSH target for remote activation

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Host-specific configuration
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "sd_mod"
      "dm-snapshot"
    ];
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
    swraid.enable = true;
  };

  environment.etc."mdadm.conf".text = "MAILADDR bernardo@meurer.org";

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "noatime"
        "size=20%"
        "mode=755"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FDA7-5E38";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/4610a590-b6b8-4a8f-82a3-9ec7592911eb";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
      ];
      neededForBoot = true;
    };
    "/mnt/music" = {
      device = "/dev/disk/by-uuid/90bcbccf-f8a0-47a7-b542-1c1a66de20e3";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "nofail"
      ];
    };
    "/mnt/music-opus" = {
      device = "/dev/disk/by-uuid/b6dc070f-5758-4bfe-8bfd-68b55da44ef1";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "nofail"
      ];
    };
  };

  # agenix-rekey host pubkey
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHws1wwXYHDmU+Bjcbw8IZv2V+fbxaTDQc44XoUQ604t";

  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
  };

  networking = {
    hostId = "55a088f6";
    hostName = "jung";
    wireless.iwd.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "02:30";
    };
    settings = {
      max-substitution-jobs = 32;
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
        "gccarch-znver3"
      ];
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    fwupd.enable = true;
    smartd.enable = true;
    syncthing.settings.folders.music = {
      devices = [ "plato" ];
      path = "/mnt/music";
      type = "receiveonly";
    };
  };

  systemd.network.networks = {
    eth = {
      DHCP = "yes";
      matchConfig.MACAddress = "1c:83:41:30:ab:9b";
      dhcpV4Config.RouteMetric = 10;
      dhcpV6Config.RouteMetric = 10;
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "60:dd:8e:12:67:bd";
      dhcpV4Config.RouteMetric = 40;
      dhcpV6Config.RouteMetric = 40;
    };
  };

  systemd.services =
    let
      mountPoints = [
        "/mnt/music"
        "/mnt/music-opus"
      ];
      mountPointUnits = builtins.map (x: "${utils.escapeSystemdPath x}.mount") mountPoints;
    in
    {
      syncthing.unitConfig = {
        Requires = mountPointUnits;
        After = mountPointUnits;
      };
      roon-server.unitConfig = {
        Requires = mountPointUnits;
        After = mountPointUnits;
      };
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/a66412e6-ff55-4053-b436-d066319ed922"; } ];

  time.timeZone = "America/New_York";

  users.groups.media = {
    gid = 999;
    members = [
      "bemeurer"
      config.services.syncthing.user
    ];
  };

  age.secrets.rootPassword.rekeyFile = ../../../secrets/jung-root-password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;

  virtualisation = {
    containers.containersConf.settings.engine.helper_binaries_dir = [ "${pkgs.netavark}/bin" ];
    oci-containers.backend = "podman";
    podman.enable = true;
  };
}
