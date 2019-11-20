{ config, ... }: {
  programs.firefox.enable = true;
  programs.newsboat.browser = "${config.programs.firefox.package}/bin/firefox";
}
