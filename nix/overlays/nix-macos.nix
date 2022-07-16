final: _: {
  nix_macos = final.nix.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/NixOS/nix/commit/b88fb50e218cd3099cbceace48f7cfdf50a8f11f.patch";
        hash = "sha256-SfMF2+pFYJGsxB4nnzJFiLgDB0pQR8Vx8d7y+Q+Koyo=";
      })
    ];
  });
}
