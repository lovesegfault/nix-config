{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
  inherit (config.networking) hostName tailscaleAddress;
in
{
  imports = with self.nixosModules; [
    services-mysql
    services-unbound
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
          type = "mysql";
          target = "blocky@unix(/run/mysqld/mysqld.sock)/blocky?charset=utf8mb4&parseTime=True&loc=Local";
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

    mysql = {
      ensureDatabases = [ "blocky" ];
      ensureUsers = [
        {
          name = "blocky";
          ensurePermissions = {
            "blocky.*" = "ALL PRIVILEGES";
          };
        }
        {
          name = "grafana";
          ensurePermissions = {
            "blocky.*" = "SELECT";
          };
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
            type = "mysql";
            url = "/run/mysqld/mysqld.sock";
            user = "grafana";
            orgId = 1;
            jsonData.database = "blocky";
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
      ${lib.optionalString (
        tailscaleAddress != null
      ) ''add_header Access-Control-Allow-Origin "http://${tailscaleAddress}";''}
      add_header Access-Control-Allow-Origin "http://127.0.0.1";
      add_header Access-Control-Allow-Origin "http://localhost";
    '';

    unbound.settings.server.port = "5335";
  };

  systemd.services = {
    blocky = {
      after = [
        "unbound.service"
        "mysql.service"
      ];
      requires = [ "unbound.service" ];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "blocky";
        Group = "blocky";
        Restart = "on-failure";
        RestartSec = "1";
        # Allow Unix socket connections to MySQL
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
      };
    };
  };

  users.users.blocky = {
    group = "blocky";
    isSystemUser = true;
  };

  users.groups.blocky = { };
}
