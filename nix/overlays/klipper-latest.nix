final: prev: {
  klipper = prev.klipper.overrideAttrs (_: {
    version = "unstable-2023-07-16";
    src = final.fetchFromGitHub {
      owner = "klipper3d";
      repo = "klipper";
      rev = "d725dfd309e3db2a7b26b9b452cfde6cb9272f34";
      hash = "sha256-LS7Xi85iSUxVD84O8ZXscUS3VUQtUc62ayhzIFCu4yQ=";
    };
  });
}
