final: _:
let
  colorcheck = { stdenv, fetchurl, perl }:

    stdenv.mkDerivation {
      pname = "colorcheck";
      version = "unstable-2008-03-03";

      src = fetchurl {
        url = "https://raw.githubusercontent.com/robertknight/konsole/6ac90416ff552abfbb9ef8880654cd5a9da6e969/tests/color-spaces.pl";
        sha256 = "sha256-1aUdYATrXcCO/9pPs3L10qV5FbTbDZRbRkZ3MmytTgE=";
      };

      dontUnpack = true;

      buildInputs = [ perl ];

      installPhase = ''
        install -D -m 755 $src $out/bin/colorcheck
      '';
    };
in
{
  colorcheck = final.callPackage colorcheck { };
}
