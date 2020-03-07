let
  overlayIncl = overlayFile: import ( ./. + "/${overlayFile}" );
  overlayFiles = builtins.attrNames (builtins.readDir ./.);
  overlayObjs = builtins.map (f: overlayIncl f ) overlayFiles;
  overlays = builtins.filter (elem: builtins.isFunction elem) overlayObjs;
in overlays
