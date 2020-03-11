let
  pkgs = import ./nix/nixpkgs.nix {};
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
