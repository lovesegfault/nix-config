self: super: {
  hyperpixel4 = self.stdenv.mkDerivation {
    pname = "hyperpixel";
    version = "2020-08-11";

    src = self.fetchFromGitHub {
      owner = "pimoroni";
      repo = "hyperpixel4";
      rev = "c5e12814a3e3da520a16c4c1433ca767b0cdbc00";
      sha256 = "1lnqvhn2zsril332ngj2sib0qsqlcjnir1xkrw7xq5wwsrwvpypv";
    };

    buildInputs = [ self.dtc (self.python3.withPackages (p: [ p.rpi-gpio ])) ];

    buildPhase = ''
      dtc -@ -I dts -O dtb -o hyperpixel4.dtbo src/hyperpixel4-common-overlay.dts
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/overlays

      cp hyperpixel4.dtbo $out/share/overlays
      cp dist/hyperpixel4-init $out/bin
    '';

    passthru = {
      overlays = "${placeholder "out"}/share/overlays";
    };
  };

  python3 = super.python3.override {
    packageOverrides = pySelf: pySuper: {
      rpi-gpio = pySelf.buildPythonPackage rec {
        pname = "RPi.GPIO";
        version = "0.7.0";

        src = pySelf.fetchPypi {
          inherit pname version;
          sha256 = "0gvxp0nfm2ph89f2j2zjv9vl10m0hy0w2rpn617pcrjl41nbq93l";
        };

        doCheck = false;
      };
    };
  };
}
