self: super: {
  beets = self.callPackage ./beets.nix { };

  python3 = super.python3.override {
    packageOverrides = pySelf: _: {
      reflink = pySelf.callPackage ./reflink.nix { };
    };
  };

  python3Packages = self.python3.pkgs;
}
