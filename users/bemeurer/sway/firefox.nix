{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };
  programs.newsboat.browser = "${config.programs.firefox.package}/bin/firefox";
}
