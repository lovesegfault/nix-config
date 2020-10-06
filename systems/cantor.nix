{ ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-gcs.nix

    ../hardware/stcg-dc.nix

    ../users/alessandro.nix
    ../users/bemeurer
    ../users/cloud.nix
    ../users/ekleog.nix
    ../users/nagisa.nix
    ../users/ogle.nix
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
    hostId = "e387c8da";
  };

  systemd.network.networks.datacenter = {
    DHCP = "yes";
    matchConfig.MACAddress = "ac:1f:6b:a4:78:6c";
  };

  time.timeZone = "America/Los_Angeles";
}
