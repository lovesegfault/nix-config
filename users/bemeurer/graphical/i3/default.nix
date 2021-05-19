{ lib, pkgs, ... }: {
  imports = [
    ./i3.nix
    ./rofi
  ];

  home.packages = with pkgs; [ xclip feh ];

  xsession = {
    enable = true;
    pointerCursor.size = lib.mkForce 16;
  };
}
