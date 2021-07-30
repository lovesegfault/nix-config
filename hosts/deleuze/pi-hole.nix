{
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--ipv6 --fixed-cidr-v6=fd00::/80";
      autoPrune.enable = true;
    };
    oci-containers.containers.pi-hole = {
      autoStart = true;
      image = "pihole/pihole:dev";
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "67:67/udp"
        "80:80/tcp"
      ];
      volumes = [
        "/etc/pihole/:/etc/pihole/"
        "/etc/dnsmasq.d/:/etc/dnsmasq.d/"
      ];
      environment = {
        CUSTOM_CACHE_SIZE = "0";
        DNSSEC = "false";
        PIHOLE_DNS_ = "127.0.0.1#5335";
        REV_SERVER = "true";
        REV_SERVER_CIDR = "10.0.0.0/24";
        REV_SERVER_DOMAIN = "localdomain";
        REV_SERVER_TARGET = "10.0.0.1";
        ServerIP = "10.0.0.2";
        ServerIPv6 = "fe80::dea6:32ff:fec1:371b";
        TZ = "America/Los_Angeles";
        WEBPASSWORD = "3zKgwWMYJd36xo2uO5glT7Nx";
        WEBTHEME = "default-darker";
      };
      extraOptions = [ "--network=host" ];
    };
  };
}
