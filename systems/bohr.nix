{ lib, ... }:
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
  ];
  environment.noXlibs = true;

  networking.hostName = "bohr";

  services.ddclient =
    let
      secretPath = ../secrets/ddclient-bohr.nix;
      secretCondition = (builtins.pathExists secretPath);
      secret = lib.optionalAttrs secretCondition (import secretPath);
    in
      (
        lib.recursiveUpdate {
          enable = true;
          ssl = true;
          protocol = "googledomains";
          domains = [ "bohr.meurer.org" ];
        } secret
      );

  services.openssh.ports = [ 22 55889 ];

  time.timeZone = "America/Los_Angeles";
}
