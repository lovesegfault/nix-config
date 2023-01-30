{ config, hostAddress, lib, pkgs, ... }:
with config.networking;
{
  imports = [
    ./unbound.nix
    ./postgresql.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [ 53 5335 ];
    allowedUDPPorts = [ 53 5335 ];
  };

  services.blocky = {
    enable = true;
    settings = {
      upstream.default = [ "127.0.0.1:5335" ];
      startVerifyUpstream = true;
      blocking = {
        blackLists.default = [
          "https://adaway.org/hosts.txt"
          "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt"
          "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
          "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
          "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt"
          "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
          "https://phishing.army/download/phishing_army_blocklist_extended.txt"
          "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
          "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
          "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
          "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
          "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
          "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
          "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
          "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
          "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
          "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
          "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
          "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
          "https://urlhaus.abuse.ch/downloads/hostfile/"
          "https://v.firebog.net/hosts/AdguardDNS.txt"
          "https://v.firebog.net/hosts/Admiral.txt"
          "https://v.firebog.net/hosts/Easylist.txt"
          "https://v.firebog.net/hosts/Easyprivacy.txt"
          "https://v.firebog.net/hosts/Prigent-Ads.txt"
          "https://v.firebog.net/hosts/Prigent-Crypto.txt"
          "https://v.firebog.net/hosts/RPiList-Malware.txt"
          "https://v.firebog.net/hosts/RPiList-Phishing.txt"
          "https://v.firebog.net/hosts/static/w3kbl.txt"
          "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
        ];
        whiteLists.default = [
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
        target = "postgres://blocky?host=/run/postgresql";
        logRetentionDays = 90;
      };
      port = "0.0.0.0:53";
      httpPort = 4000;
      bootstrapDns = "tcp+udp:1.1.1.1";
      ede.enable = true;
    };
  };

  services.postgresql = {
    ensureDatabases = [ "blocky" ];
    ensureUsers = [
      {
        name = "blocky";
        ensurePermissions."DATABASE blocky" = "ALL PRIVILEGES";
      }
      {
        name = "grafana";
        ensurePermissions."DATABASE blocky" = "CONNECT";
      }
    ];
  };

  systemd.services.postgresql.postStart = lib.mkAfter ''
    $PSQL -tAc 'GRANT pg_read_all_data TO grafana'
  '';

  services.prometheus.scrapeConfigs = [{
    job_name = "blocky";
    scrape_interval = "15s";
    static_configs = [{ targets = [ "127.0.0.1:4000" ]; }];
  }];

  services.grafana = {
    declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
    settings.panels.disable_sanitize_html = true;
    provision.datasources.settings = {
      apiVersion = 1;
      datasources = [{
        name = "Blocky Query Log";
        type = "postgres";
        url = "/run/postgresql";
        database = "blocky";
        user = "grafana";
        orgId = 1;
      }];
      deleteDatasources = [{
        name = "Blocky Query Log";
        orgId = 1;
      }];
    };
  };

  services.nginx.virtualHosts."grafana.${hostName}.meurer.org".locations."/".extraConfig = ''
    add_header Access-Control-Allow-Origin "http://${hostAddress}";
    add_header Access-Control-Allow-Origin "http://127.0.0.1";
    add_header Access-Control-Allow-Origin "http://localhost";
  '';

  services.unbound.settings.server.port = "5335";

  systemd.services.blocky = {
    after = [ "unbound.service" "postgresql.service" ];
    requires = [ "unbound.service" ];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "blocky";
      Group = "blocky";
      Restart = "on-failure";
      RestartSec = "1";
    };
  };

  users.users.blocky = {
    group = "blocky";
    isSystemUser = true;
  };

  users.groups.blocky = { };
}
