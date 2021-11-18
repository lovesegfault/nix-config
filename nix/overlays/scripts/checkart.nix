final: _: {
  checkart = final.callPackage
    (
      { writeShellApplication
      , beets
      , coreutils
      , findutils
      }: writeShellApplication {
        name = "checkart";
        runtimeInputs = [ beets coreutils findutils ];
        text = ''
          sort <<< "$(find "$1" -mindepth 2 -type d -print0 | while read -r -d $'\0' album; do [ -f "$album/cover.jpg" ] || echo "$album"; done)"
        '';
      }
    )
    { };
}
