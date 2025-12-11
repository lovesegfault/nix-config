# Overlay configuration
{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  localOverlays = lib.mapAttrs' (
    f: _: lib.nameValuePair (lib.removeSuffix ".nix" f) (import (../../overlays + "/${f}"))
  ) (builtins.readDir ../../overlays);
in
{
  flake.overlays = localOverlays // {
    default = lib.composeManyExtensions (
      [
        inputs.agenix.overlays.default
        (final: _: {
          inherit (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
        })
        (
          final: _:
          let
            nixvimPkgs = inputs.nixvim.legacyPackages.${final.stdenv.hostPlatform.system};
            nixvimModule = {
              pkgs = final;
              module = import ../../modules/home/neovim/config.nix;
            };
          in
          {
            neovim-bemeurer = nixvimPkgs.makeNixvimWithModule nixvimModule;
          }
        )
      ]
      ++ (lib.attrValues localOverlays)
    );
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.self.overlays.default ];
        config = {
          allowUnfree = true;
          allowAliases = true;
        };
      };
    };
}
