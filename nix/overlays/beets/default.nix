self: super: {
  beets = self.callPackage ./beets.nix { };

  python3 = super.python3.override {
    packageOverrides = pySelf: _: {
      confuse = pySelf.callPackage ./confuse.nix { };
      mediafile = pySelf.callPackage ./mediafile.nix { };
      reflink = pySelf.callPackage ./reflink.nix { };
    };
  };

  python3Packages = self.python3.pkgs;
}
