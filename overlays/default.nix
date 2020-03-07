let
  overlayIncl = overlayFile: import ( ./. + "/${overlayFile}" );
  overlayFiles = builtins.attrNames (builtins.readDir ./.);
  overlayMods = builtins.filter ( e: e != "default.nix" ) overlayFiles;
  overlays = builtins.map ( n: overlayIncl n) overlayMods;
in overlays
