{ config, lib, nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate

    ../../core

    ../../hardware/efi.nix
    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix
    ../../hardware/zfs.nix

    ../../users/bemeurer

    ./disko.nix
    ./state.nix
  ];

  age.secrets = {
    rootPassword.file = ./password.age;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sd_mod" ];
      systemd = {
        enable = true;
        services.rollback = {
          description = "Rollback root filesystem to a pristine state on boot";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@blank && echo "  >> >> rollback complete << <<"
          '';
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    tmp.useTmpfs = true;
    zfs.requestEncryptionCredentials = lib.mkForce [ ];
  };

  environment.systemPackages = with pkgs; [
    dig
    smartmontools
  ];

  hardware.enableRedistributableFirmware = true;

  home-manager.users.bemeurer = {
    imports = [
      ../../users/bemeurer/music
    ];
  };

  networking = {
    hostId = "e4c9bd10";
    hostName = "plato";
    firewall = {
      allowedTCPPorts = [ 32400 ];
      allowedUDPPorts = [ 32400 ];
      logRefusedConnections = false;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "-d";
    };
    settings = {
      max-substitution-jobs = 96;
      system-features = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
        "gccarch-znver3"
      ];
    };
  };

  security = {
    # acme.certs."stash.nozick.meurer.org" = { };
    pam.loginLimits = [
      { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
      { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
      { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
    ];
  };

  services = {
    chrony = {
      enable = true;
      servers = [ "time.nist.gov" "time.cloudflare.com" "time.google.com" "tick.usnogps.navy.mil" ];
    };
    smartd.enable = true;
    sshguard.enable = true;
    zfs = {
      autoScrub.pools = [ "zroot" "zdata" ];
      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd.network.networks.eth = {
    matchConfig.MACAddress = "58:11:22:c4:49:a9";
    DHCP = "yes";
  };

  time.timeZone = "Etc/UTC";

  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
