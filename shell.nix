let
  pkgs = (import ./nix).pkgs {};
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    morph
    niv
    nixpkgs-fmt
  ];
}
