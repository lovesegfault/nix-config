{ pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix

    ../../users/bemeurer
  ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  networking = {
    wireless.iwd.enable = true;
    hostName = "deleuze";
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.Name = "eth0";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    wlan = {
      DHCP = "yes";
      matchConfig.Name = "wlan0";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };

  systemd.services.dhcpd4 = {
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig.RestartSec = 2;
  };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;
}
