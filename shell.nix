let
  sources = import ./nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    (writeScriptBin "deploy" ''
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
    '')
    (cachix.overrideAttrs (oldAttrs: { doCheck = false; }))
    niv
    nixpkgs-fmt
  ];
}
