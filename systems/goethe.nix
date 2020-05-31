{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../users).andi
    (import ../users).bemeurer
    ../core

    ../hardware/rpi4.nix
  ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  networking = {
    hostName = "goethe";
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "192.168.2.1";
        prefixLength = 24;
      }];
      useDHCP = lib.mkForce false;
    };
  };

  secrets.ddclient-goethe.file = pkgs.mkSecret ../secrets/ddclient-goethe.conf;
  services.ddclient.configFile = config.secrets.ddclient-goethe;

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option subnet-mask 255.255.255.0;
        range 192.168.2.10 192.168.2.254;

        host goethe {
          hardware ethernet dc:a6:32:63:ac:71;
          fixed-address 192.168.2.1;
        }
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
      }
    '';
    interfaces = [ "eth0" ];
  };

  time.timeZone = "America/Los_Angeles";
}
