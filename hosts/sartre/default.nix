{ config, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/resolved.nix

    ../../hardware/gce.nix

    ../../users/bemeurer
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  sops.secrets.ddclient-sartre.sopsFile = ./ddclient-sartre.yaml;
  services.ddclient.configFile = config.sops.secrets.ddclient-sartre.path;

  time.timeZone = "America/Los_Angeles";

  home-manager.users.bemeurer = { ... }: {
    home.packages = with pkgs; [ weechat ];
  };
}
