{ pkgs, ... }:
{
  home.packages = with pkgs; [
    beets
    checkart
    fixart
    mediainfo
  ];
}
