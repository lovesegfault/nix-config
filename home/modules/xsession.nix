{ pkgs, ... }: {
  xsession = {
    enable = true;
    numlock.enable = true;
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 64;
    };
    profileExtra = ''
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export GDK_SCALE=2
      export GDK_DPI_SCALE=0.5
    '';
  };
}
