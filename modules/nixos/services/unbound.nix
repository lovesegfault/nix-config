{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/unbound";
      inherit (config.services.unbound) user group;
    }
  ];

  services = {
    resolved.enable = lib.mkForce false;
    prometheus = {
      scrapeConfigs = [
        {
          job_name = "unbound";
          scrape_interval = "30s";
          static_configs = [ { targets = [ "127.0.0.1:9167" ]; } ];
        }
      ];
      exporters.unbound = {
        enable = true;
        unbound.host = "unix:///run/unbound/unbound.ctl";
        user = "unbound";
      };
    };
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      localControlSocketPath = "/run/unbound/unbound.ctl";
      resolveLocalQueries = true;
      package = pkgs.unbound-full;
      settings = {
        server = {
          aggressive-nsec = true;
          cache-max-ttl = 86400;
          cache-min-ttl = 300;
          delay-close = 10000;
          deny-any = true;
          do-ip4 = true;
          do-ip6 = true;
          do-tcp = true;
          do-udp = true;
          edns-buffer-size = "1472";
          extended-statistics = true;
          harden-algo-downgrade = true;
          harden-below-nxdomain = true;
          harden-dnssec-stripped = true;
          harden-glue = true;
          harden-large-queries = true;
          harden-short-bufsize = true;
          infra-cache-slabs = 8;
          interface = [
            "0.0.0.0"
            "::"
          ];
          key-cache-slabs = 8;
          msg-cache-size = "256m";
          msg-cache-slabs = 8;
          neg-cache-size = "256m";
          num-queries-per-thread = 4096;
          num-threads = 8;
          outgoing-range = 8192;
          prefetch = true;
          prefetch-key = true;
          qname-minimisation = true;
          rrset-cache-size = "256m";
          rrset-cache-slabs = 8;
          rrset-roundrobin = true;
          serve-expired = true;
          so-rcvbuf = "4m";
          so-reuseport = true;
          so-sndbuf = "4m";
          statistics-cumulative = true;
          statistics-interval = 0;
          tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
          unwanted-reply-threshold = 100000;
          use-caps-for-id = "no";
          verbosity = 1;
          private-address = [
            "10.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "fd00::/8"
            "fe80::/10"
          ];
          private-domain = [ "local" ];
          domain-insecure = [ "local" ];
        };
      };
    };
  };
}
