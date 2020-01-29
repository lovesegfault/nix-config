{ lib, ... }: {
  imports = [
    ../combo/core.nix

    ../hardware/rpi4.nix

    ../modules/stcg-cameras.nix
  ];

  networking = {
    hostName = "camus";
    interfaces.eth0 = {
      mtu = 9000;
      ipv4.addresses = [{
        address = "192.168.2.1";
        prefixLength = 24;
      }];
      useDHCP = false;
    };
    networkmanager.unmanaged = [ "eth0" ];
  };

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      authoritative;
      option subnet-mask 255.255.255.0;
      subnet 192.168.2.0 netmask 255.255.255.0 {
        range 192.168.2.10 192.168.2.255;
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
