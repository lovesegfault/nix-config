{ config, pkgs, ... }: {
  xdg.configFile."mako/config" = {
    source = "${config.home.homeDirectory}/src/nix-config/home/files/mako.conf";
  };
}
