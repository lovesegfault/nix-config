{
  config,
  lib,
  pkgs,
  ...
}:
{
  stylix.targets.firefox.profileNames = [ "default" ];

  programs.firefox = {
    enable = true;
    # home-manager 26.05 moves the default profile location to
    # $XDG_CONFIG_HOME/mozilla/firefox and warns until the choice is explicit.
    # Adopt the XDG path; the on-disk move from ~/.mozilla/firefox is manual.
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    package =
      let
        ff =
          if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.firefox-bin then
            pkgs.firefox-bin
          else
            pkgs.firefox;
      in
      ff.override { nativeMessagingHosts = [ pkgs.tridactyl-native ]; };
  };

  xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };
}
