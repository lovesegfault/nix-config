{ config, ... }:
with config.networking;
{
  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/syncthing";
      inherit (config.services.syncthing) user group;
    }
  ];

  security.acme.certs."syncthing.${hostName}.meurer.org" = { };

  services = {
    syncthing = {
      enable = true;
      settings = {
        devices = {
          jung.id = "GXCBSO2-RQAR3CC-ACW6JWB-IAZHQZO-XZWSYKL-SYB2GNS-T4R5QO2-Q76BXAV";
          plato.id = "45XG3LH-TLUOK3W-2X2O22E-ZIKAPSP-PF3SPFF-NDIU3AR-P3LGU7T-SP32DAS";
        };
        gui = {
          insecureSkipHostcheck = true;
          insecureAdminAccess = true;
        };
      };
    };
    nginx.virtualHosts."syncthing.${hostName}.meurer.org" = {
      useACMEHost = "syncthing.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
    };
    oauth2-proxy.nginx.virtualHosts."syncthing.${hostName}.meurer.org" = { };
  };
}
