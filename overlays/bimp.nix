self: _: {
  bimp = self.writeScriptBin "bimp" ''
    #!${self.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    function error() {
        local red
        local reset
        red="$(tput setaf 1)"
        reset="$(tput sgr0)"
        printf "%s%s%s\n" "$red" "$*" "$reset"
        exit 1
    }

    function mkWorkDir() {
      if [[ ! -v WORK_DIR ]]; then
        WORK_DIR="$(mktemp -d --tmpdir=/tmp bimp.XXXXXX)"
        trap 'rm -rf $WORK_DIR' EXIT
      fi
    }

    function copyDataToWorkDir() {
      [ "$#" -eq 1 ] || error "no source set"
      local src="$1"
      mkWorkDir
      cp -r -v "$src" "$WORK_DIR"
      export MUS_DIR="$WORK_DIR/$src"
    }

    function stripId3v2() {
      [ "$#" -eq 1 ] || error "no path to strip"
      local mus="$1"
      find "$mus" -name "*.flac" | ${self.parallel}/bin/parallel --will-cite ${self.id3v2}/bin/id3v2 --delete-all {}
    }

    function reencodeFlac() {
      [ "$#" -eq 1 ] || error "no path to reencode"
      local mus="$1"
      find "$mus" -name "*.flac" | ${self.parallel}/bin/parallel --will-cite ${self.flac}/bin/flac --best -f {}
    }

    function importMus() {
      [ "$#" -eq 1 ] || error "no path to import"
      local mus="$1"
      export PATH="${self.imagemagick7}/bin:$PATH"
      ${self.beets}/bin/beet -v import --flat "$mus"
    }

    function main() {
      [ "$#" -eq 1 ] || error "wrong number of paths"
      copyDataToWorkDir "$1"
      stripId3v2 "$MUS_DIR"
      reencodeFlac "$MUS_DIR"
      importMus "$MUS_DIR"
    }

    main "$@"
  '';
}
