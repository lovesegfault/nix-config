{ config, ... }: {
  xdg.configFile.mako = {
    target = "mako/config";
    text =
      let
        homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
        homePixmaps = "${config.home.homeDirectory}/.nix-profile/share/pixmaps";
        systemIcons = "/run/current-system/sw/share/icons/hicolor";
        systemPixmaps = "/run/current-system/sw/share/pixmaps";
      in
      ''
        background-color=#0a0e14
        border-color=#53bdfa
        default-timeout=30000
        font=Iosevka 10
        icon-path=${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}
        icons=1
        max-icon-size=96
        max-visible=3
        sort=-time
        text-color=#b3b1ad
        width=500
      '';
  };
}
