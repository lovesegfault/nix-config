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
      # Hardlinking on the hot path slows builds; batch it via the
      # nix-optimise timer below instead.
      auto-optimise-store = lib.mkForce false;
      max-jobs = lib.mkForce 64;
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-znver5"
      ];
    };
    optimise.dates = lib.mkForce [ "*-*-* 00/3:00:00" ];
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

  # The yensid builders sit behind an NLB. NLB TCP idle timeout (350s
  # default) silently drops a connection that goes quiet — which the
  # ssh-ng channel always does during a long single-crate compile
  # (codegen-units=1 + opt-level=3 → rustc emits nothing for 15-25 min;
  # aws-sdk-ec2 is the canary). The local socket stays ESTAB because the
  # OS TCP keepalive is 7200s, so nix __build-remote waits forever for a
  # result that already left. ServerAliveInterval keeps the NLB flow
  # alive (60s ≪ 350s) AND turns a dead connection into a clean failure
  # in 3 min instead of an indefinite hang.
  #
  # Restores the keepalive 1ef1db4a added for putnam/keynes — d925b755
  # dropped the whole extraConfig block when it swapped the builders
  # because it was Host-scoped to the old names. The ControlMaster /
  # Ciphers / IPQoS tuning that block also carried is intentionally NOT
  # restored: ssh-ng manages its own per-build-remote ControlMaster (-S
  # /tmp/nix-<pid>-*/ssh.sock), so a user-level ControlMaster would be
  # shadowed; the cipher pin is perf-only and unverified on Graviton4.
  programs.ssh.extraConfig = ''
    Host *.yensid.rio-build.com
        ServerAliveInterval 60
        ServerAliveCountMax 3
  '';

  systemd.network.networks.ens130 = {
    DHCP = "yes";
    matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
  };

  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
