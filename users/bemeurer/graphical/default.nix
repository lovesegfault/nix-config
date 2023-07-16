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

  home.packages = with pkgs; [
    element-desktop
    libnotify
    qalculate-gtk
    xdg-utils
  ] ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    discord
    iterm2
    ledger-live-desktop
    plexamp
    signal-desktop
    thunderbird
  ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    prusa-slicer
    spotify
  ];

  programs.alacritty.enable = true;

  stylix.targets.kde.enable = false;
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
