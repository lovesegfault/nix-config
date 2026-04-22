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
    buildMachines =
      let
        mkBuilder =
          {
            hostName,
            system,
            gccarch,
            maxJobs,
            kvm,
          }:
          {
            inherit system maxJobs;
            hostName = "${hostName}?compress=true&max-connections=4";
            protocol = "ssh-ng";
            sshUser = "root";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            speedFactor = 1;
            supportedFeatures = [
              "benchmark"
              "big-parallel"
              gccarch
            ]
            ++ lib.optional kvm "nixos-test";
            mandatoryFeatures = lib.optional kvm "kvm";
          };
      in
      [
        (mkBuilder {
          hostName = "putnam";
          system = "aarch64-linux";
          gccarch = "gccarch-neoverse-v2";
          maxJobs = 128;
          kvm = false;
        })
        (mkBuilder {
          hostName = "putnam-kvm";
          system = "aarch64-linux";
          gccarch = "gccarch-neoverse-v2";
          maxJobs = 32;
          kvm = true;
        })
        (mkBuilder {
          hostName = "keynes";
          system = "x86_64-linux";
          gccarch = "gccarch-znver5";
          maxJobs = 128;
          kvm = false;
        })
        (mkBuilder {
          hostName = "keynes-kvm";
          system = "x86_64-linux";
          gccarch = "gccarch-znver5";
          maxJobs = 32;
          kvm = true;
        })
      ];
  };

  programs.ssh = {
    extraConfig = ''
      Host putnam putnam-kvm
        HostName ip-172-31-40-156.ec2.internal

      Host keynes keynes-kvm
        HostName ip-172-31-47-65.ec2.internal

      Host putnam putnam-kvm keynes keynes-kvm
        User root
        IdentitiesOnly yes
        IdentityFile /etc/ssh/ssh_host_ed25519_key
        ServerAliveInterval 30
        ServerAliveCountMax 3
        IPQoS throughput
    '';
    knownHosts = {
      putnam = {
        hostNames = [
          "putnam"
          "putnam-kvm"
          "ip-172-31-40-156.ec2.internal"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjT1p1pwoQ48meY+qSOICOaEEFnA9fZd3UPvCsa/Orw";
      };
      keynes = {
        hostNames = [
          "keynes"
          "keynes-kvm"
          "ip-172-31-47-65.ec2.internal"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWy46fPOj5Z9oV64eC028oBQhUVpR+QZgEHxt6Zj7AM";
      };
    };
  };

  systemd.network.networks.ens130 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
  };

  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
