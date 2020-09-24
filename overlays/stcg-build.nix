self: super: {
  stcg-build = super.writeScriptBin "stcg-build" ''
    #!${super.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    export DRV=$(nix-instantiate "$@")
    nix-copy-closure -s --include-outputs --to stcg-us-0005-03 "$DRV"
    ssh stcg-us-0005-03 "nix build -L $DRV"

    out=$(nix-store --query --binding out $DRV)
    nix-copy-closure -s --include-outputs --from stcg-us-0005-03 "$out"
  '';
}
