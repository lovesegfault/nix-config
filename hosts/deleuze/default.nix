{ pkgs, ... }:
{
  imports = [
    ../../core
    ../../core/resolved.nix

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  networking = {
    wireless.iwd.enable = true;
    hostName = "deleuze";
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.Name = "eth0";
    };
    wlan = {
      DHCP = "yes";
      matchConfig.Name = "wlan0";
    };
  };

  systemd.services.dhcpd4 = {
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig.RestartSec = 2;
  };

  time.timeZone = "America/Los_Angeles";
}
