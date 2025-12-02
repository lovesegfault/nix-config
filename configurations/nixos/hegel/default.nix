# NixOS configuration for hegel
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index
    inputs.stylix.nixosModules.stylix

    # Hardware modules from nixos-hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-bemeurer
    self.nixosModules.hardware-efi
    self.nixosModules.hardware-fast-networking
    self.nixosModules.hardware-no-mitigations
    self.nixosModules.hardware-nvidia
    self.nixosModules.hardware-secureboot
    self.nixosModules.services-blocky
    self.nixosModules.services-grafana
    self.nixosModules.services-nginx
    self.nixosModules.services-oauth2
    self.nixosModules.services-prometheus

    # Host-specific files
    ./disko.nix
    ./state.nix
    ./tpm-decrypt.nix
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer.imports = [ self.homeModules.music ];

  # SSH target for remote activation

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Nix registry
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };

  # Host-specific configuration
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "rfkill.default_state=0" ];
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

  networking = {
    hostId = "65618eec";
    hostName = "hegel";
    nftables.enable = true;
    tailscaleAddress = "100.109.168.118";
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      download-buffer-size = 268435456;
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

  security.pam.loginLimits = [
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

  services = {
    chrony = {
      enable = true;
      servers = [
        "time.nist.gov"
        "time.cloudflare.com"
        "time.google.com"
        "tick.usnogps.navy.mil"
      ];
      extraConfig = "allow 10.0.0.0/24";
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

  systemd.network.networks.eth0 = {
    DHCP = "yes";
    matchConfig.MACAddress = "bc:fc:e7:eb:17:d4";
    dhcpV4Config.RouteMetric = 10;
    dhcpV6Config.RouteMetric = 10;
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
