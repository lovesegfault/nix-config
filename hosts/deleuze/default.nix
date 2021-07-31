{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer

    ./unbound.nix
    ./pi-hole.nix
  ];

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
}
