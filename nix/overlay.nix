{ inputs, ... }:

let
  inherit (inputs.nixpkgs) lib;

  importLocalOverlay =
    file: lib.composeExtensions (_: _: { __inputs = inputs; }) (import (./overlays + "/${file}"));

  localOverlays = lib.mapAttrs' (
    f: _: lib.nameValuePair (lib.removeSuffix ".nix" f) (importLocalOverlay f)
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
