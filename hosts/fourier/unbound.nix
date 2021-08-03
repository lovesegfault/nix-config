{ lib, ... }: {
  boot.kernel.sysctl = {
    "net.core.rmem_default" = 31457280;
    "net.core.wmem_default" = 31457280;
    "net.core.rmem_max" = 2147483647;
    "net.core.wmem_max" = 2147483647;
  };

  services = {
    resolved.enable = lib.mkForce false;
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      localControlSocketPath = "/run/unbound/unbound.ctl";
      resolveLocalQueries = true;
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
          infra-cache-slabs = 16;
          interface = [ "127.0.0.1" ];
          key-cache-slabs = 16;
          msg-cache-size = "256m";
          msg-cache-slabs = 16;
          neg-cache-size = "256m";
          num-queries-per-thread = 4096;
          num-threads = 16;
          outgoing-range = 8192;
          port = 5335;
          prefetch = true;
          prefetch-key = true;
          qname-minimisation = true;
          rrset-cache-size = "256m";
          rrset-cache-slabs = 16;
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
          private-domain = [ "localdomain" ];
          domain-insecure = [ "localdomain" ];
        };
      };
    };
  };
}
