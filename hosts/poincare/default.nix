{ config, pkgs, ... }:
let
  dummyConfig = pkgs.writeText "darwin-configuration.nix" ''
    assert builtins.trace "This is a dummy config, use the nix-config flake!" false;
    { }
  '';
in
{
  environment = {
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../../nix/overlays} $out/overlays
    '';
    systemPackages = with pkgs; [
      coreutils
      findutils
      gawk
      git
      gnugrep
      gnused
      gnutar
      gnutls
      (openssh_gssapi.override { withKerberos = true; })
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];
  };

  homebrew = {
    enable = true;
    autoUpdate = true;
    taps = [
      "1password/tap"
      "homebrew/core"
      "homebrew/cask"
    ];
    casks = [
      "1password-cli"
      "aldente"
      "alt-tab"
      "amethyst"
      "bartender"
      "dash"
      "detexify"
      "discord"
      "element"
      "firefox"
      "google-chrome"
      "iterm2"
      "kitty"
      "knockknock"
      "ksdiff"
      "little-snitch"
      "lunar"
      "macupdater"
      "mullvadvpn"
      "nextcloud"
      "oversight"
      "parallels"
      "plexamp"
      "prusaslicer"
      "raycast"
      "roon"
      "shottr"
      "tailscale"
      "thunderbird"
      "topnotch"
      "visual-studio-code"
      "xld"
      "zoom"
      "zulip"
    ];
    cleanup = "zap";
    masApps = {
      "1Password for Safari" = 1569813296;
      "Amphetamine" = 937984704;
      "DaisyDisk" = 411643860;
      "Deliveries" = 290986013;
      "Geekbench 5" = 1478447657;
      "Kaleidoscope" = 1575557335;
      "Keynote" = 409183694;
      "LanguageTool" = 1534275760;
      "Noizio" = 928871589;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Reeder" = 1529448980;
      "Slack" = 803453959;
      "Soulver 3" = 1508732804;
      "Speedtest" = 1153157709;
      "The Unarchiver" = 425424353;
      "Xcode" = 497799835;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
  };

  home-manager.users.bemeurer = { config, ... }: {
    imports = [
      ../../users/bemeurer/core
      ../../users/bemeurer/dev
      ../../users/bemeurer/modules
    ];
    home = {
      file.".nixpkgs/darwin-configuration.nix".source = dummyConfig;

      sessionPath = [
        "${config.home.homeDirectory}/.toolbox/bin"
        "${config.home.homeDirectory}/.local/bin"
        "/opt/homebrew/bin"
      ];

      shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

      uid = 504;
    };
  };

  nix = {
    package = pkgs.nix;
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    binaryCaches = [
      "https://nix-config.cachix.org"
      "https://nix-community.cachix.org"
    ];
    daemonIONice = true;
    daemonNiceLevel = 5;
    gc.automatic = true;
    nixPath = [{
      nixpkgs = "/run/current-system/sw/nixpkgs";
      nixpkgs-overlays = "/run/current-system/sw/overlays";
    }];
    trustedUsers = [ "root" "bemeurer" ];
    useSandbox = true;
    extraOptions = ''
      !include tokens.conf
      accept-flake-config = true
      auto-optimise-store = true
      build-users-group = nixbld
      builders-use-substitutes = true
      connect-timeout = 5
      experimental-features = nix-command flakes recursive-nix
      http-connections = 0
    '';
  };

  programs = {
    fish.enable = true;
    fish.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
    zsh.enable = true;
  };

  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : kitty -1 -d ~
      '';
    };

    nix-daemon = {
      enable = true;
      logFile = "/var/log/nix-daemon.log";
    };
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 25;
        KeyRepeat = 2;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      finder.QuitMenuItem = true;
      dock.autohide = true;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  users.users.bemeurer = {
    uid = 504;
    gid = 20;
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = "/bin/zsh";
  };
}
