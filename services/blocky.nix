{
  config,
  hostAddress,
  lib,
  pkgs,
  ...
}:
with config.networking;
{
  imports = [
    ./unbound.nix
    ./postgresql.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [
      53
      5335
    ];
    allowedUDPPorts = [
      53
      5335
    ];
  };

  environment.systemPackages = with pkgs; [ blocky ];

  services = {
    blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = [ "127.0.0.1:5335" ];
        blocking = {
          denylists.default = [
            # Hagezi Pro++ - Comprehensive protection against ads, tracking, malware, phishing, scam, crypto-mining
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.plus.txt"
            # OISD Big - Well-maintained, broad coverage blocklist
            "https://raw.githubusercontent.com/sjhgvr/oisd/main/domainswild2_big.txt"
            # StevenBlack Unified Hosts - Consolidates multiple reputable sources
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];
          allowlists.default = [
            (pkgs.writeText "default.txt" ''
              www.t.co
              t.co
            '')
          ];
          clientGroupsBlock.default = [ "default" ];
        };
        caching.maxTime = -1;
        prometheus.enable = true;
        queryLog = {
          type = "postgresql";
          target = "postgres://blocky/blocky?host=/run/postgresql";
          logRetentionDays = 90;
        };
        ports = {
          dns = [ "0.0.0.0:53" ];
          http = [ "4000" ];
        };
        bootstrapDns = [ "tcp+udp:1.1.1.1" ];
        ede.enable = true;
      };
    };

    postgresql = {
      ensureDatabases = [ "blocky" ];
      ensureUsers = [
        {
          name = "blocky";
          ensureDBOwnership = true;
        }
        {
          name = "grafana";
        }
      ];
    };

    prometheus.scrapeConfigs = [
      {
        job_name = "blocky";
        scrape_interval = "15s";
        static_configs = [ { targets = [ "127.0.0.1:4000" ]; } ];
      }
    ];

    grafana = {
      declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
      settings.panels.disable_sanitize_html = true;
      provision.datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Blocky Query Log";
            type = "postgres";
            url = "/run/postgresql";
            user = "grafana";
            jsonData = {
              database = "blocky";
              sslmode = "disable";
              postgresVersion = 1700; # PostgreSQL 17
              timescaledb = false;
            };
            orgId = 1;
          }
        ];
        deleteDatasources = [
          {
            name = "Blocky Query Log";
            orgId = 1;
          }
        ];
      };
    };

    nginx.virtualHosts."grafana.${hostName}.meurer.org".locations."/".extraConfig = ''
      add_header Access-Control-Allow-Origin "http://${hostAddress}";
      add_header Access-Control-Allow-Origin "http://127.0.0.1";
      add_header Access-Control-Allow-Origin "http://localhost";
    '';

    unbound.settings.server.port = "5335";
  };

  systemd.services = {
    # XXX: I do not remember why this was here, but at some point it started
    # failing because $PSQL was gone from the postStart script. Upon commenting
    # this out, things seem to work fine, but i'm leaving this here for future
    # me (or you?).
    # postgresql.postStart = lib.mkAfter ''
    #   $PSQL -tAc 'GRANT pg_read_all_data TO grafana'
    # '';
    blocky = {
      after = [
        "unbound.service"
        "postgresql.service"
      ];
      requires = [ "unbound.service" ];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "blocky";
        Group = "blocky";
        Restart = "on-failure";
        RestartSec = "1";
      };
    };
  };

  users.users.blocky = {
    group = "blocky";
    isSystemUser = true;
  };

  users.groups.blocky = { };
}
