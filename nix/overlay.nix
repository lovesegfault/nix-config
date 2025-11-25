{ inputs, ... }:

let
  inherit (inputs.nixpkgs) lib;

  localOverlays = lib.mapAttrs' (
    f: _: lib.nameValuePair (lib.removeSuffix ".nix" f) (import (./overlays + "/${f}"))
  ) (builtins.readDir ./overlays);

in
localOverlays
// {
  default = lib.composeManyExtensions (
    [
      inputs.agenix.overlays.default
      inputs.deploy-rs.overlays.default
      inputs.lovesegfault-vim-config.overlays.default
      (final: prev: {
        inherit (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
      })
    ]
    ++ (lib.attrValues localOverlays)
  );
}
