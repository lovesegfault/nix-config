{ config, pkgs, ... }: {
  xdg.configFile."swaylock/config" = { source = ../files/swaylock.conf; };
}
