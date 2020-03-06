{
  nixpkgs.overlays = [
    (
      self: super: {
        arcanist = let
          permPatch = super.fetchpatch {
            name = "no-perm-check.patch";
            url =
              "https://gist.githubusercontent.com/lovesegfault/32ddd009f41cbd785d21db1b3d95c810/raw/a5fe1f60f1eee5b5dd35865bce8b8e8cc5a59a2c/no-perm-check.patch";
            sha256 = "0s6sc9pn6plfm5y5007986iwh9phrscvz049v5r3vb7z2s0f104i";
          };
        in
          (super.arcanist.overrideAttrs (old: { patches = [ permPatch ]; }));
      }
    )
  ];
}
