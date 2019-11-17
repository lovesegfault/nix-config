{ config, pkgs, ... }: {
  xdg.configFile."sway/config" = { source = ../files/sway.conf; };
}
