{ pkgs, ... }: {
  home.packages = with pkgs; [ bimp lollypop imagemagick essentia-extractor ];
  programs.beets.enable = true;
}
