# This is used in CI to mask the building of packages with very large closures,
# hopefully allowing GitHub to build a subset of the system drv

final:
let
  maskedPkgs = [
    "signal-desktop"
    "element-desktop"
    "thunderbird"
    "firefox-bin"
    "zoom-us"
    "discord"
    "commitizen"
  ];
  inherit (final.lib) listToAttrs nameValuePair;
  nullDrv = final.runCommand "dummy" { } ''
    echo "This is a dummy drv"
  '';

  dummyOverrides = listToAttrs (map (p: nameValuePair p nullDrv) maskedPkgs);
in
_:
dummyOverrides
