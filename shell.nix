let
  pkgs = import (import ./nix).nixpkgs {
    overlays = [ (pkgs: _: { sops-nix = pkgs.callPackage (import ./nix).sops-nix { inherit pkgs; }; }) ];
  };
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
        echo "Please specify a system"
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

  sopsPGPKeyDirs = [
    "./keys/systems"
    "./keys/users"
  ];

  buildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt
    sops-nix.ssh-to-pgp

    deploy
    genci
  ];

  shellHook = ''
    # FIXME: There must be a less stupid way of doing this
    source ${pkgs.sops-nix.sops-pgp-hook}/nix-support/setup-hook
    sopsPGPHook

    ${(import ./.).preCommitChecks.shellHook}
  '';
}
