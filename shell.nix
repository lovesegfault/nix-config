{ sources ? import ./nix/sources.nix {}
, pkgs ? import sources.nixpkgs {}
}: pkgs.mkShell {
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
