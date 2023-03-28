{ lib, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package =
      let
        ff =
          if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.firefox-bin
          then pkgs.firefox-bin
          else pkgs.firefox;
      in
      ff.override { cfg.enableTridactylNative = true; };
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
