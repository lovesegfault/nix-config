{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    ranger

    atool
    elinks
    exiftool
    ffmpegthumbnailer
    file
    imagemagick
    jq
    mediainfo
    pythonPackages.pygments
  ];
}
