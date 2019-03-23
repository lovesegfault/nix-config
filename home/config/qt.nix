{ config, pkgs, ... }:
{
  qt = if config.isDesktop then
  {
    enable = true;
    useGtkTheme = true;
  } else
  {
    enable = false;
  };
}
