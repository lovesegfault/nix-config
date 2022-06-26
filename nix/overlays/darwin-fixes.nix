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

  haskellPackages = prev.haskellPackages.extend (_: hPrev: {
    cachix = hPrev.cachix.overrideAttrs (_: {
      __propagatedImpureHostDeps = [
        "/System/Library/LaunchDaemons/com.apple.oahd.plist"
      ];
    });
    hercules-ci-cnix-store = hPrev.hercules-ci-cnix-store.overrideAttrs (_: {
      __propagatedImpureHostDeps = [
        "/System/Library/LaunchDaemons/com.apple.oahd.plist"
      ];
    });
  });
}
