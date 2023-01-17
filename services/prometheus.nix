{
  environment.persistence."/nix/state".directories = [ "/var/lib/prometheus2" ];

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
    };
  };
}
