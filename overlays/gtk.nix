self: super: {
  gtk3 = super.gtk3.overrideAttrs (
    old: rec {
      version = "3.24.18";
      src = super.fetchurl {
        url = "mirror://gnome/sources/gtk+/${super.stdenv.lib.versions.majorMinor version}/gtk+-${version}.tar.xz";
        sha256 = "1lia2ybd1661j6mvrc00iyd50gm7sy157bdzlyf4mr028rzzzspm";
      };
    }
  );
}
