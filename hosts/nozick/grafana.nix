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
        disable_login_form = true;
        login_cookie_name = "_oauth2_proxy";
        oauth_auto_login = true;
        signout_redirect_url = "https://grafana.nozick.meurer.org/oauth2/sign_out?rd=https%3A%2F%2Fgrafana.nozick.meurer.org";
      };
      "auth.basic".enabled = false;
      "auth.proxy" = {
        enabled = true;
        auto_sign_up = true;
        enable_login_token = false;
        header_name = "X-Email";
        header_property = "email";
      };
      users = {
        allow_signup = false;
        auto_assign_org = true;
        auto_assign_org_role = "Viewer";
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
