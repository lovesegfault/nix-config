final: _: {
  truecolor-check = final.callPackage (
    { writers }:
    writers.writePython3Bin "truecolor-check"
      {
        flakeIgnore = [
          "E111"
          "E114"
          "E225"
          "E226"
          "E261"
          "E265"
          "E302"
          "E305"
          "E501"
        ];
      }
      (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://gist.githubusercontent.com/raw/fdeaf79e921c2f413f44b6f613f6ad53/94d8b2be62657e96488038b0e547e3009ed87d40/colors.py";
            sha256 = "143ljymnx30axz26gg8x3q6d77g5fa8lylgjglwbdgvnk8ym7x4p";
          }
        )
      )
  ) { };
}
