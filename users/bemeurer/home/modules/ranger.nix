{ lib, pkgs, ... }: {
  home.packages = with pkgs;
    [
      ranger

      atool
      lynx
      exiftool
      file
      jq
      mediainfo
      pythonPackages.pygments
    ];
}
