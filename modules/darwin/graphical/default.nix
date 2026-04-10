{ flake, config, ... }:
let
  inherit (flake) self;
in
{
  home-manager.sharedModules = [ self.homeModules.graphical-ghostty ];

  homebrew = {
    taps = [
      "1password/tap"
    ];
    casks = [
      {
        name = "1password";
        greedy = true;
      }
      {
        name = "1password-cli";
        greedy = true;
      }
      {
        name = "aldente";
        greedy = true;
      }
      {
        name = "alt-tab";
        greedy = true;
      }
      {
        name = "appcleaner";
        greedy = true;
      }
      {
        name = "balenaetcher";
        greedy = true;
      }
      {
        name = "bartender";
        greedy = true;
      }
      {
        name = "chatgpt";
        greedy = true;
      }
      {
        name = "claude";
        greedy = true;
      }
      {
        name = "daisydisk";
        greedy = true;
      }
      {
        name = "element";
        greedy = true;
      }
      {
        name = "firefox";
        greedy = true;
      }
      {
        name = "geekbench";
        greedy = true;
      }
      {
        name = "ghostty";
        greedy = true;
      }
      {
        name = "google-chrome";
        greedy = true;
      }
      {
        name = "languagetool-desktop";
        greedy = true;
      }
      {
        name = "launchcontrol";
        greedy = true;
      }
      {
        name = "lunar";
        greedy = true;
      }
      {
        name = "macs-fan-control";
        greedy = true;
      }
      {
        name = "macupdater";
        greedy = true;
      }
      {
        name = "raycast";
        greedy = true;
      }
      {
        name = "roon";
        greedy = true;
      }
      {
        name = "signal";
        greedy = true;
      }
      {
        name = "spotify";
        greedy = true;
      }
      {
        name = "tailscale-app";
        greedy = true;
      }
      {
        name = "topnotch";
        greedy = true;
      }
      {
        name = "visual-studio-code";
        greedy = true;
      }
      {
        name = "zoom";
        greedy = true;
      }
    ];
    masApps = {
      "Keynote" = 409183694;
      "Magnet" = 441258766;
      "Noizio" = 928871589;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Speedtest" = 1153157709;
      "The Clock" = 488764545;
      "The Unarchiver" = 425424353;
      "Xcode" = 497799835;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # CustomUserPreferences would overwrite the entire AppleSymbolicHotKeys dict;
    # use -dict-add to surgically disable just Spotlight (id 64) so Raycast can claim cmd+space.
    activationScripts.postActivation.text = ''
      printf 'disabling Spotlight ⌘Space for %s...\n' '${config.system.primaryUser}'
      sudo -u '${config.system.primaryUser}' /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'
      sudo -u '${config.system.primaryUser}' /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      CustomUserPreferences."com.raycast.macos".raycastGlobalHotkey = "Command-49";
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
