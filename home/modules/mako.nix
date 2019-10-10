{ config, pkgs, ... }: {
  xdg.configFile."mako/config" = {
      source = "/home/bemeurer/.config/nixpkgs/files/mako.conf";
    };
}
