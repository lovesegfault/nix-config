self: super: {
  prusa-slicer = super.prusa-slicer.overrideAttrs (oldAttrs: rec {
    version = "2.3.0-alpha4";

    src = self.fetchFromGitHub {
      owner = "prusa3d";
      repo = "PrusaSlicer";
      sha256 = "1nix71yfzf5cl6w6q49l1jhy24lqqx5k9bvz0mdfdaf4qb70hysl";
      rev = "version_${version}";
    };

    buildInputs = oldAttrs.buildInputs ++ [ self.dbus ];
  });

  super-slicer = super.super-slicer.overrideAttrs (_: rec {
    version = "2.3.55.2";

    src = self.fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      sha256 = "0q3af3n78732v8bdqfs7crfl1y4wphbd7pli5pqj5y129chsvzwl";
      rev = version;
    };
  });
}
