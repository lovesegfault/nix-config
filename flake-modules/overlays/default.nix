{ lib, inputs, ... }:

let
  localOverlays =
    lib.mapAttrs'
      (basename: _: lib.nameValuePair
        (lib.removeSuffix ".nix" basename)
        (import (./. + "/${basename}"))
      )
      (lib.filterAttrs
        (n: _: n != "default.nix")
        (builtins.readDir ./.)
      );
in
{
  flake.overlays = localOverlays // {
    default = lib.composeManyExtensions ([
      (if inputs ? agenix then inputs.agenix.overlays.default else { })
      (if inputs ? deploy-rs then inputs.deploy-rs.overlays.default else { })
      (if inputs ? nix-fast-build then
        (final: _: {
          inherit
            (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system})
            nix-fast-build;
        }) else { })
    ] ++ (lib.attrValues localOverlays));
  };
}
