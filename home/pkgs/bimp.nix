{ pkgs, ... }:
let
  parallel = "${pkgs.parallel}/bin/parallel";
  id3v2 = "${pkgs.id3v2}/bin/id3v2";
  flac = "${pkgs.flac}/bin/flac}";
  beet = "${pkgs.beets}/bin/beet";
in
{
  nixpkgs.overlays = [
    (self: super: {
      bimp = super.writeScriptBin "bimp" ''
        #!${super.stdenv.shell}
        set -o errexit
        set -o nounset
        set -o pipefail
        [ $# -eq 1 ] || exit 1
        original_path="$1"
        path=$(mktemp -d)
        cp -r -v "$original_path" "$path"
        mus="$path/$original_path"

        find "$mus" -name "*.flac" | ${parallel} --will-cite ${id3v2} --delete-all {}
        find "$mus" -name "*.flac" | ${parallel} --will-cite ${flac} --best -f {}

        ${beet} import "$mus" || true

        rm -rf "$path"
      '';
    })
  ];
}
