self: _: {
  fixart = self.writeScriptBin "fixart" ''
    #!${self.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    trap ctrl_c INT

    function ctrl_c() {
        exit 1;
    }

    newart=$1
    [ $# -gt 1 ] || exit 1

    ${self.beets}/bin/beet clearart "''${@:2}"
    ${self.beets}/bin/beet embedart -f "$newart" "''${@:2}"
    ${self.beets}/bin/beet extractart -a "''${@:2}"

    outpath="$(${self.beets}/bin/beet ls -a -p "''${@:2}")"

    jpgs="$(${self.findutils}/bin/find "$outpath" -type f -name "*.jpg" | ${self.coreutils}/bin/wc -l)"
    [ "$jpgs" -eq 1 ] || exit 1
    echo "OK: cover count"

    original="$(${self.coreutils}/bin/sha256sum "$newart" | cut -f 1 -d " ")"
    updated="$(${self.coreutils}/bin/sha256sum "$outpath/cover.jpg" | cut -f 1 -d " ")"
    [ "$original" == "$updated" ] || exit 1
    echo "OK: SHA"
  '';
}
