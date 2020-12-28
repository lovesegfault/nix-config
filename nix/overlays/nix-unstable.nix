self: super: {
  nixUnstable = super.nixUnstable.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (self.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/4296.patch";
        sha256 = "sha256-cqGtPHTAohs30S+ThDmf+ku6arlgcgoV4D6qAZvBlyE=";
      })
    ];
  });
}
