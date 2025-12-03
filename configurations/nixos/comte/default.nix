# AWS EC2 instance (AMD Zen 5) used as a remote builder.
# Key differences from physical hosts:
#   - Uses amazon-image.nix for EC2-specific configuration
#   - networking.hostName is set dynamically by EC2, not in this config
#   - age.rekey.localStorageDir is explicit because hostname isn't known at eval time
{
  flake,
  config,
  lib,
  modulesPath,
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
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Amazon EC2 module
    "${modulesPath}/virtualisation/amazon-image.nix"

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-bemeurer
    self.nixosModules.hardware-fast-networking
    self.nixosModules.hardware-no-mitigations
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer = {
    imports = [ self.homeModules.trusted ];
    programs.git.settings.user.email = lib.mkForce "beme@anthropic.com";
  };

  # SSH target for remote activation

  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Host-specific configuration
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  hardware.enableRedistributableFirmware = true;

  # agenix-rekey host pubkey (localStorageDir override since hostName is not set)
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa";
    localStorageDir = self + "/secrets/rekeyed/comte";
  };

  networking = {
    hostId = "ec21dbce";
    nftables.enable = true;
  };

  nix.settings = {
    download-buffer-size = 268435456; # 256MiB
    max-jobs = lib.mkForce 64;
    max-substitution-jobs = 32;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-znver5"
    ];
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

  stylix.targets.grub.enable = false;

  systemd.network.networks.ens130 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
  };

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.rekeyFile = ../../../secrets/comte-root-password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
