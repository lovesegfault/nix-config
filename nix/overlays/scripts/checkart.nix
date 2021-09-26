self: _: {
  checkart = self.callPackage
    (
      { writeSaneShellScriptBin
      , beets
      , coreutils
      , findutils
      }: writeSaneShellScriptBin {
        name = "checkart";
        buildInputs = [ beets coreutils findutils ];
        src = ''
          sort <<< "$(find "$1" -mindepth 2 -type d -print0 | while read -r -d $'\0' album; do [ -f "$album/cover.jpg" ] || echo "$album"; done)"
        '';
      }
    )
    { };
}
