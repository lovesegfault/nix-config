{
  homebrew = {
    taps = [
      "1password/tap"
      "homebrew/cask"
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
      { name = "dash"; greedy = true; }
      { name = "firefox"; greedy = true; }
      { name = "google-chrome"; greedy = true; }
      { name = "ksdiff"; greedy = true; }
      { name = "lunar"; greedy = true; }
      { name = "macupdater"; greedy = true; }
      { name = "mullvadvpn"; greedy = true; }
      { name = "nextcloud"; greedy = true; }
      { name = "parallels"; greedy = true; }
      { name = "plexamp"; greedy = true; }
      { name = "quip"; greedy = true; }
      { name = "raycast"; greedy = true; }
      { name = "roon"; greedy = true; }
      { name = "shottr"; greedy = true; }
      { name = "signal"; greedy = true; }
      { name = "spotify"; greedy = true; }
      { name = "stats"; greedy = true; }
      { name = "topnotch"; greedy = true; }
      { name = "visual-studio-code"; greedy = true; }
      { name = "zoom"; greedy = true; }
      { name = "zulip"; greedy = true; }
    ];
    masApps = {
      "Geekbench 5" = 1478447657;
      "Kaleidoscope" = 1575557335;
      "Keynote" = 409183694;
      "LanguageTool" = 1534275760;
      "Noizio" = 928871589;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Soulver 3" = 1508732804;
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
      cmd - return : alacritty
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
}
