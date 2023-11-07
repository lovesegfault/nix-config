{ pkgs, ... }: {
  home.packages = with pkgs; [
    beets-unstable
    checkart
    fixart
    mediainfo
  ];
}
