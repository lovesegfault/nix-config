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
  };

  services.ddclient =
    let
      secretPath = ../secrets/ddclient-hegel.nix;
      secretCondition = (builtins.pathExists secretPath);
      secret = lib.optionalAttrs secretCondition (import secretPath);
    in
    (
      lib.recursiveUpdate
        {
          enable = true;
          ssl = true;
          protocol = "googledomains";
          domains = [ "hegel.meurer.org" ];
        }
        secret
    );


  time.timeZone = "America/Los_Angeles";
}
