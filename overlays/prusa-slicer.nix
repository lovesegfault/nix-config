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
}
