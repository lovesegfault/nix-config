let
  pkgs = import (import ./nix).nixpkgs {
    overlays = [
      (pkgs: _: rec {
        sops-nix = pkgs.callPackage (import ./nix).sops-nix { inherit pkgs; };
        ssh-to-pgp = sops-nix.ssh-to-pgp.overrideAttrs (_: { doCheck = false; });
        sops-pgp-hook = sops-nix.sops-pgp-hook;
      })
    ];
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
    ssh-to-pgp
    sops

    deploy
    genci
  ];

  shellHook = ''
    # FIXME: There must be a less stupid way of doing this
    source ${pkgs.sops-pgp-hook}/nix-support/setup-hook
    sopsPGPHook

    ${(import ./.).preCommitChecks.shellHook}
  '';
}
