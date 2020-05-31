{ config, lib, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];

  # TODO
  # environment.noXlibs = true;

  networking.hostName = "bohr";

  secrets.ddclient-bohr.file =
    let
      path = ../secrets/ddclient-bohr.conf;
    in
    if builtins.pathExists path then path else builtins.toFile "ddclient-bohr.conf" "";

  services.ddclient.configFile = config.secrets.ddclient-bohr;

  services.openssh.ports = [ 22 55889 ];

  time.timeZone = "America/Los_Angeles";
}
