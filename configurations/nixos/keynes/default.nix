# AWS EC2 instance (AMD Zen 4 / EPYC 9R45) used as a remote builder.
{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

    self.nixosModules.profiles-ec2-builder
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.kernelModules = [ "kvm-amd" ];

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWy46fPOj5Z9oV64eC028oBQhUVpR+QZgEHxt6Zj7AM";
    localStorageDir = self + "/secrets/rekeyed/keynes";
  };
  age.secrets.rootPassword.rekeyFile = ../../../secrets/keynes-root-password.age;

  networking.hostId = "1fac412f";

  nix.settings = {
    max-jobs = lib.mkForce 64;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-znver5"
    ];
  };

  systemd.network.networks.enp132s0 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:a0:f1:57:cf:25";
  };

  users.users.root = {
    hashedPasswordFile = config.age.secrets.rootPassword.path;
    # Allow comte to dispatch x86_64 builds here
    openssh.authorizedKeys.keys = [
      ''command="nix-daemon --stdio",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa root@comte''
    ];
  };
}
