{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];

  # TODO
  # environment.noXlibs = true;

  networking.hostName = "bohr";

  secrets.ddclient-bohr.file = mkSecret ../secrets/ddclient-bohr.conf;
  services.ddclient.configFile = config.secrets.ddclient-bohr;

  services.openssh.ports = [ 22 55889 ];

  time.timeZone = "America/Los_Angeles";
}
