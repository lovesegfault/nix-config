{ hostType, pkgs, ... }: {
  imports = [
    (
      if hostType == "nixos" || hostType == "homeManager" then ./linux.nix
      else if hostType == "darwin" then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for users/bemeurer/graphical"
    )
    ./kitty.nix
    ./mpv.nix
  ];

  home.packages = with pkgs; lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    discord
    element-desktop
    iterm2
    ledger-live-desktop
    libnotify
    plexamp
    qalculate-gtk
    signal-desktop
    thunderbird
  ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    prusa-slicer
    spotify
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    xdg-utils
  ];

  programs.alacritty.enable = true;

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
      package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
      name = "Hack Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
}
