# AWS EC2 instance (Graviton 4 / c8g.metal-48xl) used as a remote builder.
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
    # Hardware modules from nixos-hardware
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Amazon EC2 module
    "${modulesPath}/virtualisation/amazon-image.nix"

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.hardware-fast-networking
    self.nixosModules.hardware-no-mitigations
    self.nixosModules.pam-limits
    self.nixosModules.services-eternal-terminal
    self.nixosModules.services-podman
    self.nixosModules.users-bemeurer
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer = {
    imports = [ self.homeModules.trusted ];
    programs.git.settings.user.email = lib.mkForce "beme@anthropic.com";
  };

  # Platform
  nixpkgs.hostPlatform = "aarch64-linux";

  # Host-specific configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.persistence."/nix/state".enable = false;

  environment.systemPackages = with pkgs; [ awscli2 ];

  # agenix-rekey host pubkey (localStorageDir override since hostName is not set)
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjT1p1pwoQ48meY+qSOICOaEEFnA9fZd3UPvCsa/Orw";
    localStorageDir = self + "/secrets/rekeyed/putnam";
  };

  networking.hostId = "a8f2c7d1";

  nix.settings = {
    max-jobs = lib.mkForce 192;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-neoverse-v2"
    ];
  };

  programs.nix-ld.enable = true;

  stylix.targets.grub.enable = false;

  systemd.network.networks.enP11p4s0 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:2f:7b:0b:7c:c3";
  };

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.rekeyFile = ../../../secrets/putnam-root-password.age;
  users.users.root = {
    hashedPasswordFile = config.age.secrets.rootPassword.path;
    # Allow comte to dispatch aarch64 builds here
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa root@comte"
    ];
  };
}
