{ lib, pkgs, ... }: {
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
    ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.ffmpegthumbnailer ];
}
