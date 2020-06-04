let
  pkgs = import <nixpkgs> { };
  deploy = pkgs.writeScriptBin "deploy" ''
    #!${pkgs.stdenv.shell}
    set -o pipefail
    set -o xtrace
    set -o errexit

    trap "exit" INT TERM
    trap "kill 0" EXIT

    function vpn() {
      ${pkgs.passh}/bin/passh -c1 \
      -P "Verification code:.*" \
      -p "$(${pkgs.gopass}/bin/gopass otp otp/google.com/bernardo@standard.ai | ${pkgs.coreutils}/bin/cut -f1 -d' ')" \
      ${pkgs.sshuttle}/bin/sshuttle \
      -r bemeurer@bastion0001.us-west2.monitoring.nonstandard.ai 10.0.0.0/8 \
      --user bemeurer &
    }

    function deploy() {
      local cmd=("nix-build" "--no-out-link")
      if [ $# -gt 0 ]; then
        cmd+=("-A" "$1")
      fi
      "''${cmd[@]}" | ${pkgs.stdenv.shell}
    }

    vpn
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
}
