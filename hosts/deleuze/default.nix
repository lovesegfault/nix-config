{ lib, pkgs, ... }:
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

  services.resolved.enable = lib.mkForce false;

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
