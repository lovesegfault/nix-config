self: _: {
  screenocr = self.writeScriptBin "screenocr" ''
    #!${self.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    ${self.grim}/bin/grim -t png -g "$(${self.slurp}/bin/slurp)" - \
      | ${self.tesseract4}/bin/tesseract stdin stdout -l "eng+equ" \
      | ${self.coreutils}/bin/tr -d '\f' \
      | ${self.wl-clipboard}/bin/wl-copy
  '';
}
