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

  environment.systemPackages = with pkgs; [ plater ];

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

  systemd.enableUnifiedCgroupHierarchy = false;
  systemd.network.networks.datacenter = {
    DHCP = "yes";
    matchConfig.MACAddress = "ac:1f:6b:a4:79:34";
  };

  time.timeZone = "America/Los_Angeles";

  users.users.bemeurer.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJJo5svxvrZxwxd1Yu8z/vq1UlLaConnzDTy/ANLboi bemeurer.standard"
  ];

  virtualisation.docker.enable = true;
}
