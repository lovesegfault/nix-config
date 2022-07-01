{ config, pkgs, ... }: {
  age.secrets.vouch.file = ./vouch.age;

  environment.persistence."/nix/state".directories = [ "/var/lib/vouch-proxy" ];

  security.acme.certs."vouch.meurer.org" = { };

  services.nginx.virtualHosts = {
    "deluge.meurer.org".locations = {
      "/".extraConfig = ''
        auth_request /validate;
        proxy_set_header X-Vouch-User $auth_resp_x_vouch_user;
        error_page 401 = @error401;
      '';

      "@error401".extraConfig = ''
        return 302 https://vouch.meurer.org/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
      '';

      "/validate" = {
        proxyPass = "http://127.0.0.1:30746/validate";
        extraConfig = ''
          internal;
          proxy_pass_request_body off;
          proxy_set_header Content-Length "";
          auth_request_set $auth_resp_x_vouch_user $upstream_http_x_vouch_user;
          auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
          auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
          auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
        '';
      };
    };
    "vouch.meurer.org" = {
      useACMEHost = "vouch.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:30746";
        extraConfig = ''
          add_header Access-Control-Allow-Origin https://vouch.meurer.org;
        '';
      };
    };
  };

  systemd.services.vouch-proxy =
    let
      cfg = {
        vouch = {
          listen = "127.0.0.1";
          port = 30746;
          domains = [ "meurer.org" ];
          whiteList = [
            "bernardo@meurer.org"
          ];
        };
        oauth = {
          provider = "google";
          callback_urls = [
            "https://vouch.meurer.org/auth"
          ];
        };
      };
      cfgFile = (pkgs.formats.yaml { }).generate "config.yml" cfg;
    in
    {
      description = "Vouch Proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.vouch-proxy}/bin/vouch-proxy -config ${cfgFile}";
        EnvironmentFile = config.age.secrets.vouch.path;
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = "/var/lib/vouch-proxy";
        StateDirectory = "vouch-proxy";
        RuntimeDirectory = "vouch-proxy";
        User = "vouch-proxy";
        Group = "vouch-proxy";
        StartLimitBurst = 3;
      };
    };

  users = {
    users.vouch-proxy = {
      isSystemUser = true;
      group = "vouch-proxy";
    };
    groups.vouch-proxy = { };
  };
}
