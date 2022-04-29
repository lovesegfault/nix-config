{
  services.prometheus = {
    enable = true;
    extraFlags = [ "--storage.tsdb.retention.time=6m" ];
    scrapeConfigs = [
      {
        job_name = "local";
        scrape_interval = "10s";
        static_configs = [{
          targets = [ "127.0.0.1:9100" ];
        }];
      }
      {
        job_name = "prometheus";
        scrape_interval = "30s";
        static_configs = [{ targets = [ "127.0.0.1:9090" ]; }];
      }
    ];
    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" "pressure" ];
      disabledCollectors = [ "rapl" ];
    };
  };
}
