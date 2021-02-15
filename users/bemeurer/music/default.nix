{ pkgs, ... }: {
  home.packages = with pkgs; [ beets bimp fixart lollypop imagemagick7 essentia-extractor ];
}
