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
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.persistence."/nix/state".enable = false;

  environment.systemPackages = with pkgs; [ awscli2 ];

  hardware.enableRedistributableFirmware = true;

  # agenix-rekey host pubkey (localStorageDir override since hostName is not set)
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjT1p1pwoQ48meY+qSOICOaEEFnA9fZd3UPvCsa/Orw";
    localStorageDir = self + "/secrets/rekeyed/putnam";
  };

  networking = {
    firewall.allowedTCPPorts = [ config.services.eternal-terminal.port ];
    hostId = "a8f2c7d1";
    nftables.enable = true;
  };

  nix.settings = {
    download-buffer-size = 268435456; # 256MiB
    max-jobs = lib.mkForce 192;
    max-substitution-jobs = 32;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-neoverse-v2"
    ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs.nix-ld.enable = true;

  services.eternal-terminal.enable = true;

  stylix.targets.grub.enable = false;

  # Hardening and correctness fixes for eternal-terminal. The upstream NixOS
  # module ships no sandboxing and uses Type=forking without a PIDFile, which
  # makes systemd lose track of the daemon (restarts then fail with
  # EADDRINUSE). Running in the foreground with Type=exec avoids that entirely
  # and routes logs to the journal.
  #
  # etserver forks user shells, so those shells inherit these restrictions —
  # options that would break interactive sessions (ProtectSystem, ProtectHome,
  # MemoryDenyWriteExecute, tight capability bounding) are deliberately
  # omitted. PrivateTmp is also omitted: etserver writes the SSH agent
  # forwarding socket to /tmp, and the user session (handed off to logind)
  # lands outside the service's mount namespace, so SSH_AUTH_SOCK would point
  # to a path that doesn't exist from the shell's view.
  systemd.services.eternal-terminal.serviceConfig =
    let
      etCfg = config.services.eternal-terminal;
      cfgFile = pkgs.writeText "et.cfg" ''
        [Networking]
        port = ${toString etCfg.port}

        [Debug]
        verbose = ${toString etCfg.verbosity}
        silent = ${if etCfg.silent then "1" else "0"}
        logsize = ${toString etCfg.logSize}
      '';
    in
    {
      Type = lib.mkForce "exec";
      ExecStart = lib.mkForce "${pkgs.eternal-terminal}/bin/etserver --logtostdout --cfgfile=${cfgFile}";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "@privileged"
        "~@clock"
        "~@module"
        "~@obsolete"
        "~@raw-io"
        "~@reboot"
        "~@swap"
      ];
      LockPersonality = true;
      UMask = "0077";
    };

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
