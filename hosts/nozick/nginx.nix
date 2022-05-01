{
  security.acme.certs = {
    "deluge.meurer.org" = { };
    "grafana.meurer.org" = { };
    "plex.meurer.org" = { };
    "stash.meurer.org" = { };
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
    virtualHosts = {
      "deluge.meurer.org" = {
        useACMEHost = "deluge.meurer.org";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8112";
        };
      };
      "grafana.meurer.org" = {
        useACMEHost = "grafana.meurer.org";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "plex.meurer.org" = {
        useACMEHost = "plex.meurer.org";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:32400";
        };
      };
      "stash.meurer.org" = {
        useACMEHost = "stash.meurer.org";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9999";
        };
      };
    };
  };

  users.groups.acme.members = [ "nginx" ];
}
