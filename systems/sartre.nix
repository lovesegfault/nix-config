{ config, lib, ... }: {
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

  secrets.ddclient-sartre.file =
    let
      path = ../secrets/ddclient-sartre.conf;
    in
    if builtins.pathExists path then path else builtins.toFile "ddclient-sartre.conf" "";

  services.ddclient.configFile = config.secrets.ddclient-sartre;

  time.timeZone = "America/Los_Angeles";
}
