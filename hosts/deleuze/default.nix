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
  systemd.services.podman-pihole =
    let
      pihole = "b15b9f60394fff983902dd34f1e583a268023b30b23098702d5f8c84816d0e0a";
    in
    {
      description = "Pi-hole Podman Container";
      wants = [ "network.target" ];
      after = [ "network-online.target" "chronyd.service" ];
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
