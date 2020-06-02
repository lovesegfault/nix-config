{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core

    ../hardware/rpi4.nix
  ];

  boot.kernelParams = [ "fbcon=rotate:3" ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  secrets.wifi-stcg.file = pkgs.mkSecret ../secrets/wifi-stcg.conf;
  networking = {
    hostName = "camus";
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 24;
        }
      ];
      useDHCP = lib.mkForce false;
    };
    wireless.enable = lib.mkForce false;
    supplicant.wlan0 = {
      configFile.path = config.secrets.wifi-stcg.file;
    };
  };

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option routers 192.168.0.1;
        option subnet-mask 255.255.255.0;
        range 192.168.2.10 192.168.2.254;

        host camus {
          hardware ethernet dc:a6:32:63:47:40;
          fixed-address 192.168.2.1;
        }
        host foucault {
          hardware ethernet 48:2a:e3:61:39:66;
          fixed-address 192.168.2.2;
        }
      }
    '';
    interfaces = [ "eth0" ];
  };

  time.timeZone = "America/Los_Angeles";
}
