{ config, pkgs, ... }: {
  imports = [
    ../core
    ../dev

    ../hardware/gce.nix

    ../users/bemeurer
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  secrets.files.ddclient-sartre = pkgs.mkSecret { file = ../secrets/ddclient-sartre.conf; };
  services.ddclient.configFile = config.secrets.files.ddclient-sartre.file;

  time.timeZone = "America/Los_Angeles";
}
