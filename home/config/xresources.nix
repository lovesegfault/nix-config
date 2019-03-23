{ config, pkgs, ... }:

{
  xresources = if config.isDesktop then {
    properties = {
      "Xft.dpi" = 220;
    };
  } else {};
}
