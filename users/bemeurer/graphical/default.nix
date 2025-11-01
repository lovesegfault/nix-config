{ hostType, pkgs, ... }:
{
  imports = [
    (
      if hostType == "nixos" || hostType == "homeManager" then
        ./linux.nix
      else if hostType == "darwin" then
        ./darwin.nix
      else
        throw "Unknown hostType '${hostType}' for users/bemeurer/graphical"
    )
    ./kitty.nix
  ];

  home.packages =
    with pkgs;
    lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
      discord
      iterm2
      ledger-live-desktop
      libnotify
      qalculate-gtk
      signal-desktop
      zulip
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      prusa-slicer
      spotify
      thunderbird
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      element-desktop
      xdg-utils
      sioyek
    ];

  programs = {
    alacritty.enable = true;
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = !pkgs.stdenv.hostPlatform.isDarwin;
      # FIXME: Remove this hack when the nixpkgs pkg works again
      package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
      settings = {
        quit-after-last-window-closed = true;
      };
    };
  };

  stylix.fonts = {
    sansSerif = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Sans";
    };
    serif = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Serif";
    };
    monospace = {
      package = pkgs.nerd-fonts.hack;
      name = "Hack Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
