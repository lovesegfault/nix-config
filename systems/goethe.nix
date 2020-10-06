{ config, pkgs, ... }:
{
  imports = [
    ../core

    ../hardware/rpi4.nix

    ../users/bemeurer
  ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  networking.wireless.iwd.enable = true;

  networking.hostName = "goethe";

  secrets.files.ddclient-goethe = pkgs.mkSecret { file = ../secrets/ddclient-goethe.conf; };
  services.ddclient.configFile = config.files.secrets.ddclient-goethe.file;

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option subnet-mask 255.255.255.0;
        range 192.168.2.10 192.168.2.254;

        host foucault {
          hardware ethernet 48:2a:e3:61:39:66;
          fixed-address 192.168.2.2;
        }

        host comte {
          hardware ethernet 00:04:4b:e5:91:42;
          fixed-address 192.168.2.3;
        }

        host tis {
          hardware ethernet 00:07:48:26:4d:1d;
          fixed-address 192.168.2.4;
        }

        host aurelius {
          hardware ethernet dc:a6:32:63:ac:71;
          fixed-address 192.168.2.5;
        }
      }
    '';
    interfaces = [ "eth0" ];
  };

  systemd.network.networks = {
    lan = {
      DHCP = "no";
      address = [ "192.168.2.1/24" ];
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:c1:37:1b";
    };
    wlan = {
      DHCP = "yes";
      matchConfig.MACAddress = "dc:a6:32:c1:37:1c";
    };
  };

  systemd.services.dhcpd4 = {
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig.RestartSec = 2;
  };

  time.timeZone = "America/Los_Angeles";
}
