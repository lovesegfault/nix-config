let
  sources = import ./nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    (cachix.overrideAttrs (oldAttrs: { doCheck = false; }))
    niv
    nixpkgs-fmt
  ];
}
