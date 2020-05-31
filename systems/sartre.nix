{ config, lib, pkgs, ... }: {
  imports = [
    (import ../users).bemeurer
    ../core
    ../dev

    ../hardware/gce.nix
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  secrets.ddclient-sartre.file = pkgs.mkSecret ../secrets/ddclient-sartre.conf;
  services.ddclient.configFile = config.secrets.ddclient-sartre;

  time.timeZone = "America/Los_Angeles";
}
