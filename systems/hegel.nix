{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-gcs.nix

    ../hardware/packet-c2-large-arm.nix
  ] ++ (import ../users).stream;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
    };
    "/boot/efi" = {
      label = "boot";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "hegel";
    hostId = "69173f27";
    defaultGateway = {
      address =  "147.75.47.53";
      interface = "bond0";
    };
    defaultGateway6 = {
      address = "2604:1380:4111:8f00::";
      interface = "bond0";
    };
    bonds.bond0 = {
      interfaces = [ "eth0" "eth1" ];
      driverOptions = {
        mode = "802.3ad";
        xmit_hash_policy = "layer3+4";
        lacp_rate = "fast";
        downdelay = "200";
        miimon = "100";
        updelay = "200";
      };
    };
    interfaces = rec {
      eth0.macAddress = "98:03:9b:68:aa:50";
      eth1.macAddress = eth0.macAddress;
      bond0 = {
        useDHCP = false;
        macAddress = eth0.macAddress;
        ipv4 = {
          routes = [{
            address = "10.0.0.0";
            prefixLength = 8;
            via = "10.32.82.0";
          }];
          addresses = [
            {
              address = "147.75.47.54";
              prefixLength = 30;
            }
            {
              address = "10.32.82.1";
              prefixLength = 31;
            }
          ];
        };
        ipv6.addresses = [{
          address = "2604:1380:4111:8f00::1";
          prefixLength = 127;
        }];
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPouKApFuTmz3XSadk7mZR69bOuPJK/LO+dzFJyIbwkJ packet.net superuser"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtbU8DG8wNNq3qLeb0g6kXT2iQEU4FDFc/bXDwqcL+s Stream Team root for remote ARM builders"
  ];
}
