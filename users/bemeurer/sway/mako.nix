{ config, ... }: {
  programs.mako =
    let
      homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
      homePixmaps = "${config.home.homeDirectory}/.nix-profile/share/pixmaps";
      systemIcons = "/run/current-system/sw/share/icons/hicolor";
      systemPixmaps = "/run/current-system/sw/share/pixmaps";
    in
    {
      enable = true;
      backgroundColor = "#0a0e14";
      borderColor = "#53bdfa";
      defaultTimeout = 30 * 1000; # millis
      font = "Hack 10";
      iconPath = "${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}";
      icons = true;
      maxIconSize = 96;
      maxVisible = 3;
      sort = "-time";
      textColor = "#b3b1ad";
      width = 500;
    };
}
