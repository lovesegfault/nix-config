{ lib, pkgs, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core

    ../hardware/rpi4.nix
  ];

  console = {
    font = "ter-v28n";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  networking = {
    hostName = "goethe";
    interfaces.eth0 = {
      ipv4.addresses = [{
          address = "192.168.2.1";
          prefixLength = 24;
      }];
      useDHCP = lib.mkForce false;
    };
    wireless.networks."Tabachnik".psk = let
          secretPath = ../secrets/wifi-tabachnik.nix;
          secretCondition = (builtins.pathExists secretPath);
          secret = lib.optionalString secretCondition (import secretPath);
        in secret;
  };

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      subnet 192.168.2.0 netmask 255.255.255.0 {
        authoritative;
        option subnet-mask 255.255.255.0;
        range 192.168.2.10 192.168.2.254;

        #host camus {
        #  hardware ethernet dc:a6:32:63:47:40;
        #  fixed-address 192.168.2.1;
        #}
      }
    '';
    interfaces = [ "eth0" ];
  };

  time.timeZone = "America/Los_Angeles";
}
