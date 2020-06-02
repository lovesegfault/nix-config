{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];

  environment.noXlibs = true;

  networking = {
    hostName = "bohr";
    interfaces.eth0.useDHCP = true;
  };

  secrets.ddclient-bohr.file = pkgs.mkSecret ../secrets/ddclient-bohr.conf;
  services.ddclient.configFile = config.secrets.ddclient-bohr;

  services.openssh.ports = [ 22 55889 ];

  time.timeZone = "America/Los_Angeles";
}
