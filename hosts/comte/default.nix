{
  config,
  lib,
  modulesPath,
  nixos-hardware,
  pkgs,
  ...
}:
{
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-pc-ssd

    ../../core

    "${modulesPath}/virtualisation/amazon-image.nix"
    ../../hardware/fast-networking.nix
    ../../hardware/no-mitigations.nix

    ../../users/bemeurer
  ];

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

  networking = {
    hostId = "ec21dbce";
    nftables.enable = true;
  };

  nix = {
    settings = {
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
  };

  powerManagement.cpuFreqGovernor = "performance";

  security = {
    pam.loginLimits = [
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
  };

  stylix.targets.grub.enable = false;

  systemd.network.networks = {
    ens130 = {
      DHCP = "yes";
      matchConfig.MACAddress = "0e:1d:c4:0e:55:87";
    };
  };

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
}
