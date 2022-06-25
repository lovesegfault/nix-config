final: prev: prev.lib.optionalAttrs prev.stdenv.isDarwin {
  commitizen = final.runCommand "dummy" { } ''
    mkdir $out
  '';

  python39 = prev.python39.override {
    packageOverrides = _: pyPrev: {
      uharfbuzz = pyPrev.uharfbuzz.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ])
          ++ final.lib.optional final.stdenv.isDarwin final.darwin.apple_sdk.frameworks.ApplicationServices;
        meta = (old.meta or { }) // { broken = false; };
      });
    };
  };

  python310 = prev.python310.override {
    packageOverrides = _: pyPrev: {
      pyopenssl = pyPrev.pyopenssl.overrideAttrs (old: {
        meta = (old.meta or { }) // { broken = false; };
      });
    };
  };
}
