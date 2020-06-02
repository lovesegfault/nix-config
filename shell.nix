let
  pkgs = import <nixpkgs> { };
  deploy = pkgs.writeScriptBin "deploy" ''
    #!${pkgs.stdenv.shell}
    set -o pipefail
    set -o xtrace

    function deploy() {
      local cmd=("nix-build")
      if [ $# -gt 0 ]; then
        cmd+=("-A" "$1")
      fi
      "''${cmd[@]}" | ${pkgs.stdenv.shell}
    }

    deploy "$@"
  '';
  genci = pkgs.writeScriptBin "genci" ''
    #!${pkgs.stdenv.shell}
    set -o pipefail
    set -o xtrace

    nix-build ci.nix | ${pkgs.stdenv.shell}
  '';
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    (cachix.overrideAttrs (oldAttrs: { doCheck = false; }))
    niv
    nixpkgs-fmt
    deploy
    genci
  ];
}
