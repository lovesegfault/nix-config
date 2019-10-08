{ config, pkgs, lib, ... }:
{
  gtk = lib.mkMerge [
    {
      enable = config.isDesktop;
    }

    (lib.mkIf config.isDesktop {
      theme.package = pkgs.arc-theme;
      theme.name = "Arc";
    })
  ];
}
