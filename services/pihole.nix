{ config, ... }: {
  age.secrets.pihole.file = ./pihole.age;

  environment.persistence."/nix/state".directories = [
    "/var/lib/pihole"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 53 5335 ];
    allowedUDPPorts = [ 53 5335 ];
  };

  security.acme.certs."pihole.${config.networking.hostName}.meurer.org" = { };

  services.unbound.settings.port = "5335";

  services.nginx.virtualHosts."pihole.${config.networking.hostName}.meurer.org" = {
    useACMEHost = "pihole.${config.networking.hostName}.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8053";
      proxyWebsockets = true;
    };
  };

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:2023.1.1";
    volumes = [ "/var/lib/pihole:/etc/pihole/" ];
    environment = {
      CUSTOM_CACHE_SIZE = "0";
      DNSSEC = "false";
      REV_SERVER = "true";
      VIRTUAL_HOST = "pihole.${config.networking.hostName}.meurer.org";
      WEBTHEME = "default-darker";
    };
    environmentFiles = [ config.age.secrets.pihole.path ];
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "5335:5335/tcp"
      "5335:5335/udp"
      "8053:80/tcp"
    ];
  };
}
