{ pkgs, ... }: {
  home.packages = with pkgs; [
    (beets.override { enableAlternatives = true; })
    bimp
    checkart
    essentia-extractor
    fixart
    imagemagick
    mediainfo
  ];
}
