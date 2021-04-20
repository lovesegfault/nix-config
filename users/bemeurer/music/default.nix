{ pkgs, ... }: {
  home.packages = with pkgs; [
    (beets.override { enableAlternatives = true; })
    bimp
    fixart
    imagemagick7
    essentia-extractor
  ];
}
