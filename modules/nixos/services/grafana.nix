{ config, ... }:
with config.networking;
{
  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/grafana";
      user = "grafana";
      group = "grafana";
    }
  ];

  security.acme.certs."grafana.${hostName}.meurer.org" = { };

  services = {
    grafana = {
      enable = true;
      provision.enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          domain = "grafana.${hostName}.meurer.org";
        };
        auth = {
          disable_login_form = true;
          login_cookie_name = "_oauth2_proxy";
          oauth_auto_login = true;
          signout_redirect_url = "https://grafana.${hostName}.meurer.org/oauth2/sign_out?rd=https%3A%2F%2Fgrafana.${hostName}.meurer.org";
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
    nginx.virtualHosts."grafana.${hostName}.meurer.org" = {
      useACMEHost = "grafana.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
    oauth2-proxy.nginx.virtualHosts."grafana.${hostName}.meurer.org" = { };
  };
}
