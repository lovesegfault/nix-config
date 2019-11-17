{ config, pkgs, ... }: {
  xdg.configFile."mako/config" = { source = ../files/mako.conf; };
}
