{ lib, pkgs, ... }: {
  imports = [
    (import ../users).bemeurer
    ../core

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-cameras.nix
    ../dev/stcg-aarch64-builder.nix
    ../dev/qemu.nix
    ../dev/virt-manager.nix

    ../hardware/thinkpad-p1.nix

    ../sway
  ];

  boot.initrd.luks.devices.nixos = {
    allowDiscards = true;
    device = "/dev/disk/by-uuid/2d6ff3d0-cdfd-4b6e-a689-c43d21627279";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4e217a4b-40ae-4bde-b771-04eabfe2369d";
      fsType = "xfs";
      options = [ "defaults" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AD39-03D0";
      fsType = "vfat";
    };
  };

  hardware.u2f.enable = true;
  hardware.logitech.enable = true;

  networking = {
    hostName = "foucault";
    wireless.iwd.enable = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "stack"; value = "unlimited"; }
  ];

  services.keybase.enable = false;

  systemd.network = {
    links.enp0s31f6 = {
      linkConfig.MTUBytes = "8192";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
    };
    networks.worknet = {
      DHCP = "ipv4";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/ec8c101f-65fd-47c4-8e17-f1b5395b68c7";
  }];

  time.timeZone = "America/Los_Angeles";

  users.users.bemeurer.extraGroups = [ "kvm" "libvirtd" ];
}
