{
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
    virtualHosts = {
      "deluge.meurer.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8112";
        };
      };
      "grafana.meurer.org" = {
        # enableACME = true;
        # forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "plex.meurer.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:32400";
        };
      };
      "stash.meurer.org" = {
        # enableACME = true;
        # forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9999";
        };
      };
    };
  };
}
