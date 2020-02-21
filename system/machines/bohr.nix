{ lib, ... }:
let
  secret = ../../secrets/system/ddclient-home-lovesegfault-com.nix;
  secret_settings =
    lib.optionalAttrs (builtins.pathExists secret) (import secret);
in
{
  imports = [
    ../combo/core.nix

    ../hardware/rpi3.nix

    ../modules/sshguard.nix
  ];

  networking.hostName = "bohr";

  services.ddclient = (
    lib.recursiveUpdate {
      enable = true;
      ssl = true;
      protocol = "googledomains";
      domains = [ "home.lovesegfault.com" ];
    } secret_settings
  );

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  time.timeZone = "America/Los_Angeles";
}
