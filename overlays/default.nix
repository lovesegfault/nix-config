{ inputs }:
# Standard overlay composition without passing inputs to individual overlays
inputs.nixpkgs.lib.composeManyExtensions [
  inputs.lovesegfault-vim-config.overlays.default
  (import ./nix-latest.nix)
  (import ./scripts.nix)
  (import ./truecolor-check.nix)
]
