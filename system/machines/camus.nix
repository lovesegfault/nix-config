{ lib, ... }: {
  imports = [
    ../combo/core.nix

    ../hardware/rpi3.nix

    ../modules/stcg-cameras.nix
  ];

  networking = {
    hostName = "camus";
    interfaces.eth0.mtu = 9000;
  };

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      authoritative;
      option subnet-mask 255.255.255.0;
      subnet 192.168.2.0 netmask 255.255.255.0 {
        range 192.168.2.0 192.168.2.255;
        host camus {
          hardware ethernet b8:27:eb:77:ae:48;
          fixed-address 192.168.2.0;
        }
        host foucault {
          hardware ethernet 48:2a:e3:61:39:66;
          fixed-address 192.168.2.1;
        }
      }

    '';
    interfaces = [ "eth0" ];
  };

  time.timeZone = "America/Los_Angeles";
}
