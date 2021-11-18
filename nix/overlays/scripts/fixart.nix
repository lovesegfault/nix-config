final: _: {
  fixart = final.callPackage
    (
      { writeShellApplication
      , beets
      , coreutils
      , findutils
      }: writeShellApplication {
        name = "fixart";
        runtimeInputs = [ beets coreutils findutils ];
        text = ''
          trap ctrl_c INT

          function ctrl_c() {
              exit 1;
          }

          newart=$1
          [ $# -gt 1 ] || exit 1

          beet clearart "''${@:2}"
          beet embedart -f "$newart" "''${@:2}"
          beet extractart -a "''${@:2}"

          outpath="$(beet ls -a -p "''${@:2}")"

          jpgs="$(find "$outpath" -type f -name "*.jpg" | wc -l)"
          [ "$jpgs" -eq 1 ] || exit 1
          echo "OK: cover count"

          original="$(sha256sum "$newart" | cut -f 1 -d " ")"
          updated="$(sha256sum "$outpath/cover.jpg" | cut -f 1 -d " ")"
          [ "$original" == "$updated" ] || exit 1
          echo "OK: SHA"
        '';
      }
    )
    { };
}
