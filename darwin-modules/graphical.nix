{ config, lib, ... }:
let
  cfg = config.nix-config.graphical;
in
{
  imports = [
    ../shared-modules/graphical
  ];

  config = lib.mkIf cfg.enable {
    fonts = lib.mkIf cfg.fonts.enable {
      fonts = cfg.fonts.packages;
      fontDir.enable = true;
    };

    homebrew = {
      taps = [
        "1password/tap"
      ];
      casks = [
        { name = "1password"; greedy = true; }
        { name = "1password-cli"; greedy = true; }
        { name = "aldente"; greedy = true; }
        { name = "alt-tab"; greedy = true; }
        { name = "amethyst"; greedy = true; }
        { name = "appcleaner"; greedy = true; }
        { name = "balenaetcher"; greedy = true; }
        { name = "bartender"; greedy = true; }
        { name = "daisydisk"; greedy = true; }
        { name = "firefox"; greedy = true; }
        { name = "geekbench"; greedy = true; }
        { name = "google-chrome"; greedy = true; }
        { name = "languagetool"; greedy = true; }
        { name = "launchcontrol"; greedy = true; }
        { name = "lunar"; greedy = true; }
        { name = "macs-fan-control"; greedy = true; }
        { name = "macupdater"; greedy = true; }
        { name = "mullvadvpn"; greedy = true; }
        { name = "nextcloud"; greedy = true; }
        { name = "parallels"; greedy = true; }
        { name = "raycast"; greedy = true; }
        { name = "roon"; greedy = true; }
        { name = "shottr"; greedy = true; }
        { name = "signal"; greedy = true; }
        { name = "spotify"; greedy = true; }
        { name = "topnotch"; greedy = true; }
        { name = "visual-studio-code"; greedy = true; }
        { name = "zoom"; greedy = true; }
        { name = "zulip"; greedy = true; }
      ];
      masApps = {
        "Kaleidoscope" = 1575557335;
        "Keynote" = 409183694;
        "Noizio" = 928871589;
        "Numbers" = 409203825;
        "Pages" = 409201541;
        "Speedtest" = 1153157709;
        "The Clock" = 488764545;
        "The Unarchiver" = 425424353;
        "Xcode" = 497799835;
      };
    };

    security.pam.enableSudoTouchIdAuth = true;

    services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : open --new -a alacritty.app --args --working-directory="$HOME"
      '';
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleTemperatureUnit = "Celsius";
          InitialKeyRepeat = 25;
          KeyRepeat = 2;
          NSAutomaticSpellingCorrectionEnabled = false;
        };
        finder.QuitMenuItem = true;
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.0;
          mineffect = "scale";
          orientation = "left";
          show-recents = false;
        };
      };
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
    };
  };
}
