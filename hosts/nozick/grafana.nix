{
  environment.persistence."/nix/state".directories = [
    "/var/lib/grafana"
    "/var/lib/prometheus2"
  ];

  security.acme.certs."grafana.meurer.org" = { };

  services.grafana = {
    enable = true;
    addr = "127.0.0.1";
    extraOptions.DASHBOARDS_MIN_REFRESH_INTERVAL = "1s";
  };

  services.prometheus = {
    enable = true;
    extraFlags = [ "--storage.tsdb.retention.time=90d" ];
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
      }
      {
        job_name = "unbound";
        scrape_interval = "30s";
        static_configs = [{ targets = [ "127.0.0.1:9167" ]; }];
      }
      {
        job_name = "prometheus";
        scrape_interval = "30s";
        static_configs = [{ targets = [ "127.0.0.1:9090" ]; }];
      }
    ];
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "pressure" ];
      };
      unbound = {
        enable = true;
        controlInterface = "/run/unbound/unbound.ctl";
        user = "unbound";
      };
    };
  };

  services.nginx.virtualHosts."grafana.meurer.org" = {
    useACMEHost = "grafana.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };
}
