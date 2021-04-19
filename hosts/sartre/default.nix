{ config, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../hardware/gce.nix

    ../../users/bemeurer
  ];

  home-manager.users.bemeurer = { ... }: {
    home.packages = with pkgs; [ weechat ];
  };

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

  services.sshguard.enable = true;

  time.timeZone = "America/Los_Angeles";

  sops.secrets.root-password.sopsFile = ./root-password.yaml;
  users.users.root.passwordFile = config.sops.secrets.root-password.path;
}
