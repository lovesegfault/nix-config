{ config, pkgs, ... }: {
  xdg.configFile."swaylock/config" = {
      source = "${config.home.homeDirectory}/src/nix-config/home/files/swaylock.conf";
    };
}
