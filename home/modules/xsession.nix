{ pkgs, ... }: {
  xsession = {
    enable = true;
    numlock.enable = true;
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 64;
    };
    profileExtra  = ''
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export GDK_SCALE=2
      export GDK_DPI_SCALE=0.5
      xrandr \
      --output DP-1.1 --scale 2x2 --mode 2560x1440 --pos 3840x0 --rotate left \
      --output eDP-1-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal
    '';
  };
}
