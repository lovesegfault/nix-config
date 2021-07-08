{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../hardware/rpi4.nix
    ../../hardware/no-mitigations.nix

    ../../users/bemeurer

    ./octoprint.nix
    ./klipper.nix
  ];

  boot.loader = {
    generic-extlinux-compatible.enable = lib.mkForce false;
    raspberryPi = {
      enable = true;
      firmwareConfig = ''
        dtoverlay=vc4-fkms-v3d
      '';
      version = 4;
    };
  };

  environment.systemPackages = with pkgs; [ libraspberrypi ];

  fileSystems = lib.mkForce {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "riemann";
    firewall = {
      allowedTCPPorts = [ 5000 ];
      extraCommands = ''
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
        iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 5000
      '';
    };
    wireless.iwd.enable = true;
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:b8:bb:aa";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "dc:a6:32:b8:bb:ab";
    };
  };

  time.timeZone = "America/Los_Angeles";

  # sops.secrets.root-password.sopsFile = ./root-password.yaml;
  # users.users.root.passwordFile = config.sops.secrets.root-password.path;
}
