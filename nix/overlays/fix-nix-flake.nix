final: prev: {
  nix = prev.nix.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5839.patch";
        sha256 = "sha256-vuguZQx6v8TKzfQLAg4P6HbTp/ECtZ/6JJvjrzYha+E=";
      })
    ];
  });
}
