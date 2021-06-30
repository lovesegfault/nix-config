{
  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option subnet-mask 255.255.255.0;
        range 192.168.2.2 192.168.2.254;
      }
    '';
    interfaces = [ "eth0" ];
  };
}
