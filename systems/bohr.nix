{ lib, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];

  networking.hostName = "bohr";

  services.ddclient =
    let
      secretPath = ../secrets/ddclient-home.nix;
      secretCondition = (builtins.pathExists secretPath);
      secret = lib.optionalAttrs secretCondition (import secretPath);
    in
      (
        lib.recursiveUpdate {
          enable = true;
          ssl = true;
          protocol = "googledomains";
          domains = [ "home.meurer.org" ];
        } secret
      );

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  time.timeZone = "America/Los_Angeles";
}
