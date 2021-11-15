{ deploy-rs
, gitignore
, nixpkgs
, ragenix
, ...
}:

let
  inherit (nixpkgs.lib) mapAttrs' nameValuePair removeSuffix;
  inherit (builtins) readDir;
  localOverlays = mapAttrs'
    (n: _: nameValuePair
      (removeSuffix ".nix" n)
      (final: prev: import (./overlays + "/${n}") final prev))
    (readDir ./overlays);
in
{
  deploy-rs = final: prev: deploy-rs.overlay final prev;
  gitignore = final: prev: gitignore.overlay final prev;
  ragenix = final: prev: ragenix.overlay final prev;
} // localOverlays
