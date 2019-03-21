{ config, pkgs, ... }:
{
  xdg = if config.isDesktop then
  {
    enable = true;
  } else
  {
    enable = false;
  };
}
