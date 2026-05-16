# AWS EC2 instance (AMD Zen 5) used as a remote builder.
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
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdXiTjpN4zgnC8x9d0LLhWwKLohHkPchuORcus0zWAa";
    localStorageDir = self + "/secrets/rekeyed/comte";
  };
  age.secrets.rootPassword.rekeyFile = ../../../secrets/comte-root-password.age;

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
    # yensid: load-balanced bare-metal pools (2× r8a.metal-48xl on :22,
    # 2× r8g.metal-48xl on :2222). nix's ssh-ng store ignores ssh_config
    # Port, so the arm pool's :2222 must be in the URI.
    buildMachines =
      let
        yensid =
          {
            host,
            system,
            gccarch,
          }:
          {
            hostName = "${host}?max-connections=4";
            systems = [ system ];
            protocol = "ssh-ng";
            sshUser = "builder-ssh";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            maxJobs = 64;
            speedFactor = 2;
            supportedFeatures = [
              "benchmark"
              "big-parallel"
              "kvm"
              "nixos-test"
              gccarch
            ];
          };
      in
      [
        (yensid {
          host = "x86-64-linux.yensid.rio-build.com";
          system = "x86_64-linux";
          gccarch = "gccarch-znver5";
        })
        (yensid {
          host = "aarch64-linux.yensid.rio-build.com:2222";
          system = "aarch64-linux";
          gccarch = "gccarch-neoverse-v2";
        })
      ];
  };

  systemd.tmpfiles.rules = [
    "D /nix/var/nix/current-load 0755 root root - -"
  ];

  # yensid's builders all present one shared host key (the SSM-fetched
  # builder-ca-client-key) plus a CA-signed cert. Pin both: the
  # certAuthority entry is the forward-compatible path, the plain-key
  # pin keeps things working if cert validation fails (OpenSSH 10.2+
  # rejects empty-principal certs — fixed on the CA side, but
  # belt-and-suspenders).
  programs.ssh.knownHosts = {
    yensid-ca = {
      certAuthority = true;
      hostNames = [
        "yensid.rio-build.com"
        "*.yensid.rio-build.com"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3TEgIFuRf18rB9tWDfNCZfprjC0hjMgSj2MTGu5jQY";
    };
    yensid-host = {
      hostNames = [
        "yensid.rio-build.com"
        "*.yensid.rio-build.com"
        "[*.yensid.rio-build.com]:2222"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAITrSOgy0iKn61kHpVt+eaej1swHtWSpFuR5Ci8ej8J";
    };
  };

  systemd.network.networks.ens130 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
  };

  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
