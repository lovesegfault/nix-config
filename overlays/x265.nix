self: _: {
  x265 = (self.callPackage
    (self.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/99e25c33f8a7b6bdd4c25975f6efb1cab471618b/pkgs/development/libraries/x265/default.nix";
      sha256 = "14c81jd4dhhhw60i2abb37ba0inn0rvhramqs5n2d33vwy6sa4rw";
    })
    { }).overrideAttrs (_: {
    patches = self.lib.optionals self.stdenv.hostPlatform.isAarch64 [
      (self.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/99e25c33f8a7b6bdd4c25975f6efb1cab471618b/pkgs/development/libraries/x265/0001-dynamicHDR10-update-CMakeLists.txt-for-aarch64-suppo.patch";
        sha256 = "1r7vrlgp8q723p5vigay7nd0mvzi22qrx5v9wswgz3p3cm7ir8dp";
      })
    ];
  });
}
