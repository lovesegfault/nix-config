{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  boot = {
    kernel.sysctl = {
      "net.core.rmem_max" = 1048576;
      "net.core.wmem_max" = 1048576;
    };
    kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4_lto;
  };

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  networking = {
    hostName = "deleuze";
    firewall = {
      allowedTCPPorts = [ 80 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  nix.gc = {
    automatic = true;
    options = "-d";
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
          cache-max-ttl = 86400;
          cache-min-ttl = 300;
          deny-any = true;
          do-ip4 = true;
          do-ip6 = false;
          do-tcp = true;
          do-udp = true;
          edns-buffer-size = "1472";
          harden-algo-downgrade = true;
          harden-dnssec-stripped = true;
          harden-glue = true;
          harden-large-queries = true;
          harden-short-bufsize = true;
          interface = [ "127.0.0.1" ];
          msg-cache-size = "128m";
          neg-cache-size = "64m";
          num-threads = "1";
          port = 5335;
          prefer-ip6 = false;
          prefetch = true;
          prefetch-key = true;
          qname-minimisation = true;
          rrset-cache-size = "256m";
          rrset-roundrobin = true;
          serve-expired = true;
          so-rcvbuf = "4m";
          so-reuseport = true;
          so-sndbuf = "4m";
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

  systemd.network.networks.lan = {
    DHCP = "yes";
    matchConfig.MACAddress = "dc:a6:32:c1:37:1b";
  };

  systemd.services.podman-pihole =
    let
      pihole = "b15b9f60394fff983902dd34f1e583a268023b30b23098702d5f8c84816d0e0a";
    in
    {
      description = "Pi-hole Podman Container";
      wants = [ "network.target" ];
      after = [ "network-online.target" ];
      environment.PODMAN_SYSTEMD_UNIT = "%n";
      serviceConfig = {
        ExecStart = "${pkgs.podman}/bin/podman start ${pihole}";
        ExecStop = "${pkgs.podman}/bin/podman stop -t 10 ${pihole}";
        ExecStopPost = "${pkgs.podman}/bin/podman stop -t 10 ${pihole}";
        PIDFile = "/run/containers/storage/overlay-containers/${pihole}/userdata/conmon.pid";
        Restart = "on-failure";
        TimeoutStopSec = 70;
        Type = "forking";
      };
      unitConfig.RequiresMountsFor = [ "/run/containers/storage" ];
      wantedBy = [ "multi-user.target" ];
    };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
