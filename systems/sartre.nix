{ config, pkgs, ... }: {
  imports = [
    ../core
    ../core/unbound.nix

    ../hardware/gce.nix

    ../users/bemeurer
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  nix.gc.automatic = true;

  secrets.files.ddclient-sartre = pkgs.mkSecret { file = ../secrets/ddclient-sartre.conf; };
  services.ddclient.configFile = config.secrets.files.ddclient-sartre.file;

  time.timeZone = "America/Los_Angeles";

  home-manager.users.bemeurer = { ... }: {
    home.packages = with pkgs; [ weechat ];
  };
}
