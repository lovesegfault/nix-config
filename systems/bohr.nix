{ lib, ... }:
let
  secretPath = ../secrets/ddclient-home.nix;
  secretCondition = (builtins.pathExists secretPath);
  secret = lib.optionalAttrs secretCondition (import secretPath);
in
{
  imports = [
    (import ../users).bemeurer
    ../core
    ../hardware/rpi3.nix
    ../misc/sshguard.nix
  ];

  networking.hostName = "bohr";

  services.ddclient = (
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
