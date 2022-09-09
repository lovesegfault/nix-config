{
  environment.persistence."/nix/state".directories = [
    "/var/lib/grafana"
    "/var/lib/prometheus2"
  ];

  security.acme.certs."grafana.nozick.meurer.org" = { };

  services.grafana = {
    enable = true;
    addr = "127.0.0.1";
    domain = "grafana.nozick.meurer.org";
    extraOptions = {
      AUTH_BASIC_ENABLED = "false";
      AUTH_DISABLE_LOGIN_FORM = "true";
      AUTH_LOGIN_COOKIE_NAME = "_oauth2_proxy";
      AUTH_OAUTH_AUTO_LOGIN = "true";
      AUTH_PROXY_AUTO_SIGN_UP = "true";
      AUTH_PROXY_ENABLED = "true";
      AUTH_PROXY_ENABLE_LOGIN_TOKEN = "false";
      AUTH_PROXY_HEADERS = "Name:X-User Email:X-Email";
      AUTH_PROXY_HEADER_NAME = "X-Email";
      AUTH_PROXY_HEADER_PROPERTY = "email";
      AUTH_SIGNOUT_REDIRECT_URL = "https://grafana.nozick.meurer.org/oauth2/sign_out";
      USERS_ALLOW_SIGNUP = "false";
      USERS_AUTO_ASSIGN_ORG = "true";
      USERS_AUTO_ASSIGN_ORG_ROLE = "Admin";
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
    extraConfig = ''
      ssl_client_certificate /etc/ssl/certs/origin-pull-ca.pem;
      ssl_verify_client on;
    '';
  };

  services.oauth2_proxy.nginx.virtualHosts = [ "grafana.nozick.meurer.org" ];
}
