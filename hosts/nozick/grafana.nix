{
  environment.persistence."/nix/state".directories = [
    "/var/lib/grafana"
    "/var/lib/prometheus2"
  ];

  security.acme.certs."grafana.nozick.meurer.org" = { };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        domain = "grafana.nozick.meurer.org";
      };
      auth = {
        "basic.enabled" = false;
        disable_login_form = true;
        login_cookie_name = "_oauth2_proxy";
        oauth_auto_login = true;
        signout_redirect_url = "https://grafana.nozick.meurer.org/oauth2/sign_out";
        "proxy.auto_sign_up" = true;
        "proxy.enabled" = true;
        "proxy.enable_login_token" = false;
        "proxy.headers" = "Name:X-User Email:X-Email";
        "proxy.header_name" = "X-Email";
        "proxy.header_property" = "email";
      };
      users = {
        allow_signup = false;
        auto_assign_org = true;
        auto_assign_org_role = "Editor";
      };
    };
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

  services.nginx.virtualHosts."grafana.nozick.meurer.org" = {
    useACMEHost = "grafana.nozick.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };

  services.oauth2_proxy.nginx.virtualHosts = [ "grafana.nozick.meurer.org" ];
}
