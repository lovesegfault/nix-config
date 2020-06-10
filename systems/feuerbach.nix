{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-aarch64-builder.nix

    ../hardware/stcg-dc.nix

    ../users/andi.nix
    ../users/bemeurer
    ../users/cloud.nix
    ../users/ekleog.nix
    ../users/nagisa.nix
    ../users/ogle.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9f013ec7-5f6f-49a6-9deb-4b58b5a486b7";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/88B1-403B";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/841350f8-099e-4b46-9530-443912b92d48"; }];

  networking = {
    hostName = "feuerbach";
    hostId = "791cadf8";
  };

  systemd.network.networks.datacenter = {
    DHCP = "yes";
    matchConfig.MACAddress = "ac:1f:6b:a4:79:34";
  };

  time.timeZone = "America/Los_Angeles";

  virtualisation.docker.enable = true;
}
