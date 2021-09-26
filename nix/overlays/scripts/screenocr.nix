self: _: {
  screenocr = self.callPackage
    (
      { writeSaneShellScriptBin
      , coreutils
      , grim
      , slurp
      , tesseract4
      , wl-clipboard
      }: writeSaneShellScriptBin {
        name = "screenocr";

        buildInputs = [ coreutils grim slurp tesseract4 wl-clipboard ];

        src = ''
          grim -t png -g "$(slurp)" - \
            | tesseract stdin stdout -l "eng+equ" \
            | tr -d '\f' \
            | wl-copy
        '';
      }
    )
    { };
}
