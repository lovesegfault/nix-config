let
  pkgs = import (import ./nix).nixpkgs { };
  deploy = pkgs.writeScriptBin "deploy" ''
    #!${pkgs.stdenv.shell}
    set -o pipefail
    set -o xtrace
    set -o errexit

    trap "exit" INT TERM
    trap "kill 0" EXIT

    function deploy() {
      if [ $# -gt 0 ]; then
        nix-build --no-out-link -A "$1" | ${pkgs.stdenv.shell}
      else
        echo "Please specify a host"
      fi
    }

    deploy "$@"
    exit
  '';
  genci = pkgs.writeScriptBin "genci" ''
    #!${pkgs.stdenv.shell}
    set -o pipefail
    set -o xtrace

    nix-build --no-out-link ci.nix | ${pkgs.stdenv.shell}
  '';
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt

    deploy
    genci
  ];
  shellHook = "${(import ./.).preCommitChecks.shellHook}";
}
