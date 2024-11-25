{ config, ... }:
with config.networking;
{
  environment.persistence."/nix/state".directories = with config.services.jellyfin; [
    {
      directory = cacheDir;
      inherit user group;
    }
    {
      directory = dataDir;
      inherit user group;
    }
  ];

  security.acme.certs."jellyfin.${hostName}.meurer.org" = { };

  services = {
    jellyfin.enable = true;
    nginx.virtualHosts."jellyfin.${hostName}.meurer.org" = {
      useACMEHost = "jellyfin.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };
  };
}
