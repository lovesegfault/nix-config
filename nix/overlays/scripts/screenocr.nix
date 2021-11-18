final: _: {
  screenocr = final.callPackage
    (
      { writeShellApplication
      , coreutils
      , grim
      , slurp
      , tesseract4
      , wl-clipboard
      }: writeShellApplication {
        name = "screenocr";

        runtimeInputs = [ coreutils grim slurp tesseract4 wl-clipboard ];

        text = ''
          grim -t png -g "$(slurp)" - \
            | tesseract stdin stdout -l "eng+equ" \
            | tr -d '\f' \
            | wl-copy
        '';
      }
    )
    { };
}
