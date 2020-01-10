{ config, lib, pkgs, ... }: let
  secret = ../../share/secrets/modules/ddclient-home-lovesegfault-com.nix;
  secret_settings = if builtins.pathExists secret then import secret else {
    username = ""; password = ""; };
in {
  imports = [
    ../combo/core.nix

    ../hardware/rpi3.nix

    ../modules/sshguard.nix
    ../modules/ddclient.nix
  ];

  networking.hostName = "bohr";

  services.ddclient = (lib.recursiveUpdate {
    ssl = true;
    protocol = "googledomains";
    domains = [ "home.lovesegfault.com" ];
  } secret_settings);

  time.timeZone = "America/Los_Angeles";
}
