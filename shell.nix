{ sources ? import ./nix/sources.nix {} }:
let
  pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt
    shfmt
    shellcheck
    ctags
  ];
}
