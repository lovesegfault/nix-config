{ deploy-rs
, gitignore
, nixgl
, nixpkgs
, ragenix
, ...
}:

let
  inherit (nixpkgs.lib) composeManyExtensions;
  inherit (builtins) attrNames readDir;
  localOverlays = map
    (f: import (./overlays + "/${f}"))
    (attrNames (readDir ./overlays));
in
composeManyExtensions (localOverlays ++ [
  deploy-rs.overlay
  gitignore.overlay
  nixgl.overlay
  ragenix.overlay
])
