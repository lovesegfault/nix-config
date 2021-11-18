final: _: {
  colorcheck = final.callPackage
    (
      { stdenv, fetchurl, perl }:

      stdenv.mkDerivation {
        pname = "colorcheck";
        version = "unstable-2008-03-03";

        src = fetchurl {
          url = "https://raw.githubusercontent.com/robertknight/konsole/master/tests/color-spaces.pl";
          sha256 = "sha256-1aUdYATrXcCO/9pPs3L10qV5FbTbDZRbRkZ3MmytTgE=";
        };

        dontUnpack = true;

        buildInputs = [ perl ];

        installPhase = ''
          install -D -m 755 $src $out/bin/colorcheck
        '';
      }
    )
    { };
}
