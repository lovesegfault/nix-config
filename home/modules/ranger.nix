{ config, pkgs, ... }: {
  home.packages = with pkgs;
    [
      ranger

      atool
      lynx
      exiftool
      file
      imagemagick
      jq
      mediainfo
      pythonPackages.pygments
    ] ++ (if pkgs.stdenv.isLinux then [ pkgs.ffmpegthumbnailer ] else [ ]);
}
