{ config, ... }: {
  xdg.configFile.mako = {
    target = "mako/config";
    text = let
      systemIcons = "/run/current-system/sw/share/icons/hicolor";
      homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
    in ''
      background-color=#0a0e14
      border-color=#53bdfa
      default-timeout=30000
      font=Hack 10
      icon-path=${homeIcons}:${systemIcons}
      icons=1
      max-visible=-1
      sort=-time
      text-color=#b3b1ad
      width=500
    '';
  };
}
