{ config, nixos-hardware, pkgs, ... }:
{
  imports = [
    nixos-hardware.common-pc-ssd

    ../../core

    ../../hardware/rpi4.nix
    ../../hardware/nixos-aarch64-builder
    ../../hardware/no-mitigations.nix

    ../../users/bemeurer
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "earlycon=pl011,mmio32,0xfe201000" "console=ttyAMA0,115200" ];
  };

  console.keyMap = "us";

  hardware = {
    raspberry-pi."4" = {
      dwc2 = {
        enable = true;
        dr_mode = "host";
      };
      i2c1.enable = true;
    };
  };

  networking.hostName = "camus";

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks.eth = {
    DHCP = "yes";
    matchConfig.MACAddress = "e4:5f:01:2a:4e:88";
  };

  time.timeZone = "America/Los_Angeles";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;

  swapDevices = [{ device = "/swap"; size = 2048; }];
}
