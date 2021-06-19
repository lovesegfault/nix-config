self: super: {
  nixUnstable = super.nixUnstable.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (self.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/4911.patch";
        sha256 = "sha256-UgRqbchS/M8d4WWzsvNlFqQP2wZbRTbbUVk/TIcHJiw=";
      })
    ];
  });
}
