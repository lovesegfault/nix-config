final: _: {
  bluez_unstable = (final.bluez5.overrideAttrs (old: rec {
    version = "unstable-2022-02-18";
    src = final.fetchFromGitHub {
      owner = "bluez";
      repo = "bluez";
      rev = "8fe1e5e165ad7b4f7c318f507aa85cd747401b81";
      hash = "sha256-tCMkynV17xkY/AmkkIrq8XosK8B337nQ54GgCKlfOeo=";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      final.autoreconfHook
    ];
  })).override { withExperimental = false; };
}
