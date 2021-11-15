{ agenix, deploy-rs, nixpkgs, ... }:
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
  agenix = final: prev: agenix.overlay final prev;
  deploy-rs = final: prev: deploy-rs.overlay final prev;
} // localOverlays
