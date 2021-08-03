{ lib, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    loader = {
      generic-extlinux-compatible.enable = lib.mkForce false;
      raspberryPi = {
        enable = true;
        firmwareConfig = ''
          uart_2ndstage=1
          dtoverlay=disable-bt

          over_voltage=6
          arm_freq=2000

          dtoverlay=dwc2,dr_mode=host

          dtparam=i2c_arm=on
          dtoverlay=i2c-rtc,ds3231

          dtoverlay=rpi-poe
          dtparam=poe_fan_temp0=50000
          dtparam=poe_fan_temp1=60000
          dtparam=poe_fan_temp2=70000
          dtparam=poe_fan_temp3=80000
        '';
        version = 4;
      };
    };
    kernelParams = [ "earlycon=pl011,mmio32,0xfe201000" "console=ttyAMA0,115200" ];
  };

  fileSystems = lib.mkForce {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "camus";
    firewall.trustedInterfaces = [ "eth0" ];
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks.eth = {
    DHCP = "yes";
    matchConfig.MACAddress = "e4:5f:01:2a:4e:88";
  };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--ipv6 --fixed-cidr-v6=fd00::/80";
      autoPrune.enable = true;
    };
  };
}
