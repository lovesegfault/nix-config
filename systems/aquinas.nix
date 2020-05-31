{ config, lib, pkgs, ... }: {
  imports = [
    (import ../users).bemeurer
    ../core

    ../dev

    ../hardware/dell-e6530.nix

    ../sway
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e8d15b70-f22d-4119-b3c1-ce115ba65c04";
      fsType = "xfs";
      options = [ "defaults" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/DE57-1596";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "aquinas";
  };

  secrets.ddclient-aquinas.file = pkgs.mkSecret ../secrets/ddclient-aquinas.conf;
  services.ddclient.configFile = config.secrets.ddclient-aquinas;

  services.logind.lidSwitchExternalPower = "ignore";

  services.openssh.ports = [ 22 55888 ];

  swapDevices =
    [{ device = "/dev/disk/by-uuid/57cf59f5-7ad6-49bc-b5b0-21796be1e617"; }];

  time.timeZone = "America/Los_Angeles";
}
