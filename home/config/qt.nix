{ config, pkgs, ... }:
{
  qt = if config.isDesktop then
  {
    enable = true;
    platformTheme = "gnome";
  } else
  {
    enable = false;
  };
}
