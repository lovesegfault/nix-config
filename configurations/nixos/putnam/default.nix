# AWS EC2 instance (Graviton 4 / c8g.metal-48xl) used as a remote builder.
{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = [
    self.nixosModules.profiles-ec2-builder
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjT1p1pwoQ48meY+qSOICOaEEFnA9fZd3UPvCsa/Orw";
    localStorageDir = self + "/secrets/rekeyed/putnam";
  };
  age.secrets.rootPassword.rekeyFile = ../../../secrets/putnam-root-password.age;

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

  systemd.network.networks.enP11p4s0 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:2f:7b:0b:7c:c3";
  };

  users.users.root = {
    hashedPasswordFile = config.age.secrets.rootPassword.path;
    # Allow comte to dispatch aarch64 builds here
    openssh.authorizedKeys.keys = [
      ''command="nix-daemon --stdio",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa root@comte''
    ];
  };
}
