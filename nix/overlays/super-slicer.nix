self: super: {
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
