final: _: {
  checkart = final.callPackage
    (
      { writeShellApplication
      , coreutils
      , findutils
      }: writeShellApplication {
        name = "checkart";
        runtimeInputs = [ coreutils findutils ];
        text = ''
          sort <<< "$(find "$1" -mindepth 2 -type d -print0 | while read -r -d $'\0' album; do [ -f "$album/cover.jpg" ] || echo "$album"; done)"
        '';
      }
    )
    { };
}
