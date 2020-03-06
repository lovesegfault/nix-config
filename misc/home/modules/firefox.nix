{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;
  };
  programs.newsboat.browser = "${config.programs.firefox.package}/bin/firefox";
}
