{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  boot = {
    kernel.sysctl."net.core.rmem_max" = 1048576;
    kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4_lto;
  };

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  networking = {
    wireless.iwd.enable = true;
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

  systemd.network = {
    netdevs.wifi-eth-bond = {
      netdevConfig = {
        Name = "wifi-eth-bond";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        PrimaryReselectPolicy = "always";
        MIIMonitorSec = "1s";
      };
    };
    networks = {
      eth-bond = {
        matchConfig.MACAddress = "dc:a6:32:c1:37:1b";
        bond = [ "wifi-eth-bond" ];
        networkConfig.PrimarySlave = true;
      };
      wifi-bond = {
        matchConfig.MACAddress = "dc:a6:32:c1:37:1c";
        bond = [ "wifi-eth-bond" ];
      };
      wifi-eth-bond = {
        matchConfig.Name = "wifi-eth-bond";
        DHCP = "ipv4";
      };
    };
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
          do-ip6 = false;
          do-ip4 = true;
          do-tcp = true;
          do-udp = true;
          edns-buffer-size = "1472";
          harden-dnssec-stripped = true;
          harden-glue = true;
          interface = [ "127.0.0.1" ];
          num-threads = "2";
          port = 5335;
          prefer-ip6 = false;
          prefetch = true;
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
          tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
          use-caps-for-id = "no";
          verbosity = 1;
        };
        forward-zone = [{
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }];
      };
    };
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
