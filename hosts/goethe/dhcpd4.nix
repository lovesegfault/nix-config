{ pkgs, ... }: {
  services.dhcpd4 = {
    enable = true;
    configFile = pkgs.writeText "dhcpd4.conf" ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        range 192.168.2.1 192.168.2.254;
        default-lease-time 3600;
        max-lease-time 3600;
        option subnet-mask 255.255.255.0;
        option broadcast-address 192.168.2.255;

        host goethe {
          hardware ethernet dc:a6:32:a7:29:c3;
          fixed-address 192.168.2.1;
        }
      }
    '';
    interfaces = [ "eth0" ];
  };

  systemd.services.dhcpd4 = {
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig.RestartSec = 2;
  };
}
