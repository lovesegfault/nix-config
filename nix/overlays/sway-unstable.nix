final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-08-13";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "2c64f36e8886d1f26daeb2a4ee79f3f9dd3d4c85";
      hash = "sha256-elHu3d82STGB+pTGPj1K9eOyWGsotqUX4e0ZQ+db4Rg=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-08-11";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "b44015578a3d53cdd9436850202d4405696c1f52";
      hash = "sha256-gTsZWtvyEMMgR4vj7Ef+nb+wcXkwGivGfnhnBIfPHOA=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
