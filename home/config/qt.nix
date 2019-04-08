{ config, pkgs, lib, ... }:
{
  qt = lib.mkMerge [
    {
      enable = config.isDesktop;
    }

    (lib.mkIf config.isDesktop {
      platformTheme = "gnome";
    })
  ];
}
