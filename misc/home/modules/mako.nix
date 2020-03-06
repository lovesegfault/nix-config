{ config, pkgs, ... }: {
  xdg.configFile.mako = {
    target = "mako/config";
    text = ''
      background-color=#0a0e14
      border-color=#53bdfa
      default-timeout=30000
      font=Hack 10
      icon-path="~/.nix-profile/share/icons/hicolor/64x64"
      icons=1
      max-visible=-1
      sort=-time
      text-color=#b3b1ad
      width=500
    '';
  };
}
