{ pkgs, ... }: {
  home.packages = with pkgs; [ beets bimp lollypop imagemagick essentia-extractor ];
}
