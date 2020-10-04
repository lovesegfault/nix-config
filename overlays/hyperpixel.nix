self: super: {
  hyperpixel4-init = self.stdenv.mkDerivation {
    pname = "hyperpixel4-init";
    version = "2020-08-11";

    src = self.fetchFromGitHub {
      owner = "pimoroni";
      repo = "hyperpixel4";
      rev = "6633ee6b63dc6cf8ae5463852b4a24527b8c52f9";
      sha256 = "02qizyp01kfxc7759hcy02b14b489bayfpp5pir97341cwj1l59p";
    };

    buildInputs = [ self.libgpiod ];

    buildPhase = ''
      gcc -o hyperpixel4-init src/hyperpixel4-init.c -lgpiod
    '';

    installPhase = ''
      mkdir -p $out/bin

      install -m 0755 hyperpixel4-init -t $out/bin
    '';
  };

  hyperpixel4 = self.stdenv.mkDerivation {
    pname = "hyperpixel4";
    version = "2020-08-11";

    src = self.fetchFromGitHub {
      owner = "pimoroni";
      repo = "hyperpixel4";
      rev = "c5e12814a3e3da520a16c4c1433ca767b0cdbc00";
      sha256 = "1lnqvhn2zsril332ngj2sib0qsqlcjnir1xkrw7xq5wwsrwvpypv";
    };

    buildInputs = [ self.dtc ];

    buildPhase = ''
      dtc -@ -I dts -O dtb -o hyperpixel4-common.dtbo src/hyperpixel4-common-overlay.dts
      dtc -@ -I dts -O dtb -o hyperpixel4-0x14.dtbo src/hyperpixel4-0x14-overlay.dts
      dtc -@ -I dts -O dtb -o hyperpixel4-0x5d.dtbo src/hyperpixel4-0x5d-overlay.dts
    '';

    installPhase = ''
      mkdir -p $out/share/overlays
      mkdir -p $out/share/sources

      install *.dtbo -t $out/share/overlays
      install src/*.dts -t $out/share/sources
    '';
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
