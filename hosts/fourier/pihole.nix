{
  networking.firewall = {
    allowedTCPPorts = [ 80 53 5335 ];
    allowedUDPPorts = [ 53 5335 ];
  };

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:latest";
    volumes = [
      "/var/lib/pihole/etc/php:/etc/php/"
      "/var/lib/pihole/etc/pihole:/etc/pihole/"
      "/var/lib/pihole/etc/dnsmasq.d/:/etc/dnsmasq.d/"
    ];
    environment = {
      CUSTOM_CACHE_SIZE = "0";
      DNSSEC = "false";
      PIHOLE_DNS_ = "127.0.0.1#5335";
      REV_SERVER = "true";
      REV_SERVER_CIDR = "10.0.0.0/24";
      REV_SERVER_DOMAIN = "localdomain";
      REV_SERVER_TARGET = "10.0.0.1";
      ServerIP = "10.0.0.3";
      ServerIPv6 = "fe80::1ac0:4dff:fe31:c5f";
      TZ = "America/Los_Angeles";
      WEBPASSWORD = "3zKgwWMYJd36xo2uO5glT7Nx";
      WEBTHEME = "default-darker";
    };
    extraOptions = [ "--network=host" ];
  };
}
