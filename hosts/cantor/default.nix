{ pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../dev
    ../../dev/stcg-gcs

    ../../hardware/nixos-aarch64-builder
    ../../hardware/stcg-dc.nix

    ../../users/bemeurer
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4d662b7c-e395-49d6-86ad-237ed28eb885";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/41D0-C874";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/e4cdc2fd-eda2-45dd-a250-ea08a5250b9e"; }];

  networking = {
    hostName = "cantor";
    hostId = "2677931c";
  };

  systemd.enableUnifiedCgroupHierarchy = false;
  systemd.network.networks.datacenter = {
    DHCP = "yes";
    matchConfig.MACAddress = "ac:1f:6b:a4:78:6c";
  };

  time.timeZone = "America/Los_Angeles";

  users.users.bemeurer.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJJo5svxvrZxwxd1Yu8z/vq1UlLaConnzDTy/ANLboi bemeurer.standard"
  ];

  virtualisation.docker.enable = true;
}
