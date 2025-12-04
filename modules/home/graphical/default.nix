{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  imports = [
    self.homeModules.graphical-kitty
  ]
  ++ lib.optionals isLinux [ self.homeModules.graphical-linux ];

  home.packages =
    with pkgs;
    lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
      libnotify
      qalculate-gtk
      signal-desktop
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
    ]
    ++ lib.optionals isLinux [
      xdg-utils
    ];

  programs = {
    alacritty.enable = true;
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = isLinux;
      package = if isDarwin then null else pkgs.ghostty;
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
    monospace =
      if isDarwin then
        { name = "Berkeley Mono Variable"; }
      else
        {
          package = pkgs.nerd-fonts.hack;
          name = "Hack Nerd Font";
        };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
