self: super: {
  # FIXME: remove on next nixpkgs bump
  libplacebo = super.libplacebo.overrideAttrs (_: {
    patches = [
      (self.fetchpatch {
        url = "https://code.videolan.org/videolan/libplacebo/-/commit/523056828ab86c2f17ea65f432424d48b6fdd389.patch";
        sha256 = "051vhd0l3yad1fzn5zayi08kqs9an9j8p7m63kgqyfv1ksnydpcs";
      })
    ];
  });
}
