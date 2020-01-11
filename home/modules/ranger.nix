{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    ranger

    atool
    lynx
    exiftool
    ffmpegthumbnailer
    file
    imagemagick
    jq
    mediainfo
    pythonPackages.pygments
  ];
}
