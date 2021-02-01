self: _: {
  screenocr = self.callPackage
    (
      { writeShellScriptBin
      , coreutils
      , grim
      , lib
      , slurp
      , tesseract4
      , wl-clipboard
      }: writeShellScriptBin "screenocr" ''
        set -o errexit
        set -o nounset
        set -o pipefail

        export PATH="${lib.makeBinPath [ coreutils grim slurp tesseract4 wl-clipboard ]}:$PATH"

        grim -t png -g "$(slurp)" - \
          | tesseract stdin stdout -l "eng+equ" \
          | tr -d '\f' \
          | wl-copy
      ''
    ) { };
}
