{ deploy-rs
, gitignore
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
  ragenix.overlay
])
