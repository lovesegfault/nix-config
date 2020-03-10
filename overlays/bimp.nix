self: super: {
  bimp = let
    parallel = "${super.parallel}/bin/parallel";
    id3v2 = "${super.id3v2}/bin/id3v2";
    flac = "${super.flac}/bin/flac";
    beet = "${super.beets}/bin/beet";
  in super.writeScriptBin "bimp" ''
    #!${super.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail
    [ $# -eq 1 ] || exit 1
    original_path="$1"
    path=$(mktemp -d -p /tmp)
    cp -r -v "$original_path" "$path"
    mus="$path/$original_path"

    find "$mus" -name "*.flac" | ${parallel} --will-cite ${id3v2} --delete-all {}
    find "$mus" -name "*.flac" | ${parallel} --will-cite ${flac} --best -f {}

    export PATH="${super.imagemagick}/bin:$PATH"
    ${beet} import "$mus" || true

    rm -rf "$path"
  '';
}
