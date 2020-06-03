{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];

  environment.noXlibs = true;

  networking.hostName = "bohr";

  secrets.ddclient-bohr.file = pkgs.mkSecret ../secrets/ddclient-bohr.conf;
  services.ddclient.configFile = config.secrets.ddclient-bohr;

  services.openssh.ports = [ 22 55889 ];

  systemd.network.networks.eth0 = {
    DHCP = "yes";
    matchConfig.MACAddress = "b8:27:eb:2d:4c:18";
  };

  time.timeZone = "America/Los_Angeles";
}
