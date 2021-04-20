{ pkgs, ... }: {
  home.packages = with pkgs; [
    (beets.override { enableAlternatives = true; })
    bimp
    essentia-extractor
    fixart
    imagemagick7
    mediainfo
  ];
}
