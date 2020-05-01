let
  sources = import ./nix;
  pkgs = sources.pkgs { };
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    morph
    niv
    nixpkgs-fmt
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
  '';
}
