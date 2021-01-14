{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };
  programs.newsboat.browser = "${config.programs.firefox.package}/bin/firefox";
}
