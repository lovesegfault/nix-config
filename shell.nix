let
  pkgs = (import ./nix).pkgs {};
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt
    morph
    shfmt
    shellcheck
    ctags
  ];
}
