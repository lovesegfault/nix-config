{ deploy-rs, nixpkgs, ragenix, ... }:
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
  ragenix = final: prev: ragenix.overlay final prev;
  deploy-rs = final: prev: deploy-rs.overlay final prev;
} // localOverlays
