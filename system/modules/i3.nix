{ pkgs, ... }: {
  services.xserver = rec {
    enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager.extraSessionFilePackages = [ windowManager.i3.package ];

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        alacritty
        scrot
        light
        dunst
        feh
        i3lock
        polybar
        xclip
        xsel
      ];
    };

    xautolock.locker =
      "${pkgs.i3lock}/bin/i3lock -i ~/pictures/walls/clouds.png -e -f";
  };
}
