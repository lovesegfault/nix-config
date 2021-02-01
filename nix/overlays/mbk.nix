self: _: {
  mbk = self.callPackage
    (
      { writeSaneShellScriptBin, google-cloud-sdk }: writeSaneShellScriptBin {
        name = "mbk";

        buildInputs = [ google-cloud-sdk ];

        script = ''
          DOCUMENTS_BUCKET="gs://documents.meurer.org"
          MISC_BUCKET="gs://misc.meurer.org"
          MUSIC_BUCKET="gs://music.meurer.org"
          PICTURES_BUCKET="gs://pictures.meurer.org"

          function backup() {
              local src="$1"
              local dst="$2"

              if [ -z ''${DEBUG+x} ]; then
                  gsutil -m rsync -d -r "$src" "$dst"
              else
                  gsutil -m rsync -d -r -n "$src" "$dst"
              fi
          }

          function main() {
              # main dirs
              backup "$HOME/documents" "$DOCUMENTS_BUCKET"
              backup "$HOME/music" "$MUSIC_BUCKET"
              backup "$HOME/pictures" "$PICTURES_BUCKET"
              # weirder state dirs
              backup "$HOME/.local/share/shotwell" "$MISC_BUCKET/shotwell"
              backup "$HOME/.local/share/lollypop" "$MISC_BUCKET/lollypop"
          }

          main
        '';
      }
    )
    { };
}
