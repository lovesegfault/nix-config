{ lib, ... }: {
  imports = [
    (import ../users).bemeurer
    ../core
    ../dev

    ../hardware/gce.nix
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  services.ddclient =
    let
      secretPath = ../secrets/ddclient-sartre.nix;
      secretCondition = (builtins.pathExists secretPath);
      secret = lib.optionalAttrs secretCondition (import secretPath);
    in
      (
        lib.recursiveUpdate {
          enable = true;
          ssl = true;
          protocol = "googledomains";
          domains = [ "sartre.meurer.org" ];
        } secret
      );

  time.timeZone = "America/Los_Angeles";
}
