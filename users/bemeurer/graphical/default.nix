{
  config,
  hostType,
  lib,
  pkgs,
  ...
}:
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
      iterm2
      libnotify
      qalculate-gtk
      signal-desktop
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      xdg-utils
    ];

  programs =
    let
      ifAvailable = lib.meta.availableOn pkgs.stdenv.hostPlatform;
    in
    {
      alacritty.enable = true;
      discord.enable = ifAvailable config.programs.discord.package;
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
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      sioyek.enable = true;
      element-desktop.enable = true;
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
      if hostType == "darwin" then
        {
          name = "Berkeley Mono Variable";
        }
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
