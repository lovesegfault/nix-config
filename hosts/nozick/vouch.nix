{ config, pkgs, ... }: {
  age.secrets.vouch.file = ./vouch.age;

  environment.persistence."/nix/state".directories = [ "/var/lib/vouch-proxy" ];

  security.acme.certs."vouch.meurer.org" = { };

  services.nginx.virtualHosts = {
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
