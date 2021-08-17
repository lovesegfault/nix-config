{
  networking.firewall.allowedTCPPorts = [ 9090 9091 ];

  services.prometheus = {
    enable = true;
    extraFlags = [ "--storage.tsdb.retention.time=1y" ];
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "5s";
        static_configs = [{
          targets = [
            "127.0.0.1:9091"
            "127.0.0.1:9167"
            "cantor:9091"
            "feuerbach:9091"
          ];
        }];
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
        listenAddress = "127.0.0.1";
        enabledCollectors = [ "systemd" "pressure" ];
        disabledCollectors = [ "rapl" ];
        port = 9091;
      };
      unbound = {
        controlInterface = "/run/unbound/unbound.ctl";
        enable = true;
        port = 9167;
        user = "unbound";
      };
    };
  };
}
