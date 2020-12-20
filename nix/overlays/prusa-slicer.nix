self: super: {
  prusa-slicer = super.prusa-slicer.overrideAttrs (oldAttrs: rec {
    version = "2.3.0-beta2";

    src = self.fetchFromGitHub {
      owner = "prusa3d";
      repo = "PrusaSlicer";
      sha256 = "1msjhghvwdmca57vy3l5mcycb2qy8p0sxm4vnnndjqg65h0d11w2";
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
