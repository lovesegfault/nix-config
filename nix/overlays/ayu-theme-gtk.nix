self: _: {
  ayu-theme-gtk = self.callPackage
    (
      { stdenv
      , fetchFromGitHub
      , sassc
      , autoreconfHook
      , pkg-config
      , gtk3
      , gnome3
      , gtk-engine-murrine
      , optipng
      , inkscape
      }:
      stdenv.mkDerivation rec {
        pname = "ayu-theme";
        version = "2017-05-12-unstable";

        src = fetchFromGitHub {
          owner = "dnordstrom";
          repo = pname;
          rev = "cc6f3d3b72897c304e2f00afcaf51df863155e35";
          sha256 = "sha256-1EhTfPhYl+4IootTCCE04y6V7nW1/eWdHarfF7/j1U0=";
        };

        postPatch = ''
          ln -sn 3.20 common/gtk-3.0/3.24
          ln -sn 3.18 common/gnome-shell/3.24
        '';

        nativeBuildInputs = [
          autoreconfHook
          pkg-config
          sassc
          optipng
          inkscape
          gtk3
        ];

        propagatedUserEnvPkgs = [
          gnome3.gnome-themes-extra
          gtk-engine-murrine
        ];

        enableParallelBuilding = true;

        preBuild = ''
          # Shut up inkscape's warnings about creating profile directory
          export HOME="$NIX_BUILD_ROOT"
        '';

        configureFlags = [
          "--with-gnome-shell=${gnome3.gnome-shell.version}"
          "--disable-unity"
        ];

        postInstall = ''
          install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
        '';
      }
    )
    { };
}
