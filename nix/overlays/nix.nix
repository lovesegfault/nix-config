final: prev: {
  nix = final.nixVersions.nix_2_15.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/NixOS/nix/commit/1ad8638557c86cff1d1f104e7b4f7c3064d0ea18.patch";
        hash = "sha256-kSRiPwih4YssJ+bgqBN0xNuV8edhLKnONqb/Pve0g78=";
      })
    ];
  });
}
