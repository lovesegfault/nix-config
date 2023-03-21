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
  ] ++ (builtins.filter (lib.meta.availableOn hostPlatform) [
    discord
    iterm2
    ledger-live-desktop
    plexamp
    signal-desktop
    thunderbird
  ]);
}
