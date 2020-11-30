self: super: {
  prusa-slicer = super.prusa-slicer.overrideAttrs (oldAttrs: rec {
    version = "2.3.0-beta1";

    src = self.fetchFromGitHub {
      owner = "prusa3d";
      repo = "PrusaSlicer";
      sha256 = "06r7zy9zxxz1hkmib67v5ay492w6d12flj0jqkr4xs5fg151v8g7";
      rev = "version_${version}";
    };

    buildInputs = oldAttrs.buildInputs ++ [ self.dbus ];
  });

  super-slicer = super.super-slicer.overrideAttrs (_: rec {
    version = "2.3.55.2-unstable";

    src = self.fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      sha256 = "0s297jwa8pndbg67nxrfjvmjb2fcy7xvqykbsxhmdyybldslplpl";
      rev = "fa4aab027bf39570e2b0b55f2f88780ebcc00f83";
    };
  });
}
