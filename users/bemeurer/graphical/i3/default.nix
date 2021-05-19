{ lib, pkgs, ... }: {
  imports = [
    ./i3.nix
    ./rofi
  ];

  home.packages = with pkgs; [ xclip feh ];

  xsession = {
    enable = true;
    profileExtra = ''
      export MOZ_USE_XINPUT2=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"

      xrdb ~/.Xresources
    '';
    pointerCursor.size = lib.mkForce 16;
  };
}
