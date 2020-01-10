{ pkgs, ... }: {
  services.xserver = rec {
    enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager.sessionPackages = [ windowManager.i3.package ];

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        alacritty
        scrot
        gebaar-libinput
        light
        dunst
        feh
        i3lock
        polybar
        xclip
        xsel
      ];
    };

    xautolock.locker = "${pkgs.i3lock}/bin/i3lock -i ~/.wall -e -f";
  };
}
