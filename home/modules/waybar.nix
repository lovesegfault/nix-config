{ config, pkgs, ... }: {
  xdg.configFile."waybar/config" = { source = ../files/waybar.conf; };
  xdg.configFile."waybar/style.css" = { source = ../files/waybar.style.css; };
}
