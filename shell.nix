let
  sources = import ./nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
  '';
}
