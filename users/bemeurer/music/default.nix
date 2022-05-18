{ pkgs, ... }: {
  home.packages = with pkgs; [
    beets-unstable
    bimp
    checkart
    essentia-extractor
    fixart
    imagemagick
    mediainfo
  ];
}
