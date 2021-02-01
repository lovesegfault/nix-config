self: _: {
  bimp = self.callPackage
    (
      { writeSaneShellScriptBin
      , beets
      , flac
      , id3v2
      , imagemagick
      , parallel
      }: writeSaneShellScriptBin {
        name = "bimp";

        buildInputs = [
          beets
          flac
          id3v2
          imagemagick
          parallel
        ];

        script = ''
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
            find "$mus" -name "*.flac" | parallel --will-cite id3v2 --delete-all {}
          }

          function reencodeFlac() {
            [ "$#" -eq 1 ] || error "no path to reencode"
            local mus="$1"
            find "$mus" -name "*.flac" | parallel --will-cite flac --best -f {}
          }

          function importMus() {
            [ "$#" -eq 1 ] || error "no path to import"
            local mus="$1"
            beet -v import --flat "$mus"
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
    )
    { };
}
