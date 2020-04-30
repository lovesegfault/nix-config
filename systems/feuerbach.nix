{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-gcs.nix

    ../hardware/aarch64-build-box.nix
    ../hardware/stcg-dc.nix
  ] ++ (import ../users).stream;

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

  time.timeZone = "America/Los_Angeles";
  virtualisation.docker.enable = true;
}
