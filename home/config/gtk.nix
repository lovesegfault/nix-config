{ config, pkgs, ... }:
{
  gtk = if config.isDesktop then
  {
    enable = true;
    theme.package = pkgs.arc-theme;
    theme.name = "Arc";
  } else
  {
    enable = false;
  };
}
