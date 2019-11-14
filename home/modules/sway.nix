{ config, pkgs, ... }: {
  xdg.configFile."sway/config" = {
    source = "${config.home.homeDirectory}/src/nix-config/home/files/sway.conf";
  };
}
