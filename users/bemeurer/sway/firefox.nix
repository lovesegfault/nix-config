{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package =
      if pkgs.hostPlatform.system == "x86_64-linux"
      then pkgs.firefox-bin
      else pkgs.firefox;
  };
  programs.newsboat.browser = "${config.programs.firefox.package}/bin/firefox";
}
