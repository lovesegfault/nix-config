final: prev: {
  python310 = prev.python39.override {
    packageOverrides = _: pyPrev: {
      uharfbuzz = pyPrev.uharfbuzz.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          final.darwin.apple_sdk.frameworks.ApplicationServices
        ];
        meta = (old.meta or { }) // { broken = false; };
      });
    };
  };
}
