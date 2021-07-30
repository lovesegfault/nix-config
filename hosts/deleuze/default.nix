{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer

    ./unbound.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4_lto;

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
    chrony = {
      enable = true;
      servers = [ "time.nist.gov" "time.cloudflare.com" "time.google.com" "tick.usnogps.navy.mil" ];
      extraConfig = ''
        allow 10.0.0.0/24
      '';
    };
    timesyncd.enable = lib.mkForce false;
  };

  systemd.network.networks.lan = {
    DHCP = "yes";
    matchConfig.MACAddress = "dc:a6:32:c1:37:1b";
  };

  systemd.services.unbound.after = [ "chronyd.service" ];

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--ipv6 --fixed-cidr-v6=fd00::/80";
      autoPrune.enable = true;
    };
    oci-containers.containers.pi-hole = {
      autoStart = true;
      image = "pihole/pihole:dev";
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "67:67/udp"
        "80:80/tcp"
      ];
      volumes = [
        "/etc/pihole/:/etc/pihole/"
        "/etc/dnsmasq.d/:/etc/dnsmasq.d/"
      ];
      environment = {
        CUSTOM_CACHE_SIZE = "0";
        DNSSEC = "false";
        PIHOLE_DNS_ = "127.0.0.1#5335";
        REV_SERVER = "true";
        REV_SERVER_CIDR = "10.0.0.0/24";
        REV_SERVER_DOMAIN = "localdomain";
        REV_SERVER_TARGET = "10.0.0.1";
        ServerIP = "10.0.0.2";
        ServerIPv6 = "fe80::dea6:32ff:fec1:371b";
        TZ = "America/Los_Angeles";
        WEBPASSWORD = "3zKgwWMYJd36xo2uO5glT7Nx";
        WEBTHEME = "default-darker";
      };
      extraOptions = [ "--network=host" ];
    };
  };
}
