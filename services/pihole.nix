{ config, ... }: {
  age.secrets.pihole.file = ./pihole.age;

  environment.persistence."/nix/state".directories = [
    "/var/lib/pihole"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 80 53 5335 ];
    allowedUDPPorts = [ 53 5335 ];
  };

  services.unbound.settings.port = "5335";

  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:2023.1.1";
    volumes = [ "/var/lib/pihole:/etc/pihole/" ];
    environment = {
      CUSTOM_CACHE_SIZE = "0";
      DNSSEC = "false";
      REV_SERVER = "true";
      WEBTHEME = "default-darker";
    };
    environmentFiles = [ config.age.secrets.pihole.path ];
    extraOptions = [ "--network=host" ];
  };
}
