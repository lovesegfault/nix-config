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
    # Hardware modules from nixos-hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
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
  nixpkgs.hostPlatform = "x86_64-linux";

  # Host-specific configuration
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.persistence."/nix/state".enable = false;

  environment.systemPackages = with pkgs; [ awscli2 ];

  # agenix-rekey host pubkey (localStorageDir override since hostName is not set)
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa";
    localStorageDir = self + "/secrets/rekeyed/comte";
  };

  networking.hostId = "ec21dbce";

  nix = {
    settings = {
      max-jobs = lib.mkForce 64;
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-znver5"
      ];
    };
    buildMachines = [
      {
        hostName = "putnam";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        maxJobs = 192;
        speedFactor = 2;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
          "gccarch-neoverse-v2"
        ];
      }
    ];
  };

  programs.ssh = {
    extraConfig = ''
      Host putnam
        HostName ip-172-31-40-156.ec2.internal
        User root
        IdentitiesOnly yes
        IdentityFile /etc/ssh/ssh_host_ed25519_key
    '';
    knownHosts.putnam = {
      hostNames = [
        "putnam"
        "ip-172-31-40-156.ec2.internal"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjT1p1pwoQ48meY+qSOICOaEEFnA9fZd3UPvCsa/Orw";
    };
  };

  programs.nix-ld.enable = true;

  stylix.targets.grub.enable = false;

  systemd.network.networks.ens130 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
  };

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.rekeyFile = ../../../secrets/comte-root-password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
