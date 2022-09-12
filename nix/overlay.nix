{ deploy-rs
, nixpkgs
, ragenix
, ...
}:

let
  inherit (nixpkgs) lib;
  localOverlays =
    lib.mapAttrs'
      (f: _: lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (import (./overlays + "/${f}")))
      (builtins.readDir ./overlays);

in
localOverlays // {
  default = lib.composeManyExtensions ((lib.attrValues localOverlays) ++ [
    deploy-rs.overlay
    ragenix.overlay
  ]);
}
