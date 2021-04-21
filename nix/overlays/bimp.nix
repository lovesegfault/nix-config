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

        src = ''
          function mkWorkDir() {
            if [[ ! -v WORK_DIR ]]; then
              WORK_DIR="$(mktemp -d --tmpdir=/tmp bimp.XXXXXX)"
              trap 'rm -rf $WORK_DIR' EXIT
            fi
          }

          function copyDataToWorkDir() {
            local src="$1"
            mkWorkDir
            cp -r -v "$src" "$WORK_DIR"
            export MUS_DIR="$WORK_DIR/$src"
          }

          function stripId3v2() {
            local mus="$1"
            find "$mus" -name "*.flac" | parallel --will-cite id3v2 --delete-all {}
          }

          function reencodeFlac() {
            local mus="$1"
            find "$mus" -name "*.flac" | parallel --will-cite flac -p -e --best -f {}
          }

          function importMus() {
            local mus="$1"
            beet -v import --flat "$mus"
          }

          function main() {
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
