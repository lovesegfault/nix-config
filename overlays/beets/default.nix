self: super: rec {
  beets = self.callPackage ./beets.nix { pythonPackages = self.python3Packages; };

  python3 = super.python3.override {
    packageOverrides = self: super: {
      confuse = super.callPackage ./confuse.nix { };
      mediafile = super.callPackage ./mediafile.nix { };
      mutagen = super.mutagen.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ ./mutagen-no-mmap.patch ];
      });
    };
  };

  python3Packages = python3.pkgs;
}
