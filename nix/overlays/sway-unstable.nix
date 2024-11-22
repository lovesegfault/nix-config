final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-11-22";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "b2c3c371fcb39578464c5604e6010ff5f656cdc2";
      hash = "sha256-LktMTPA8maz33l13+FosyXPZh9xMk1zA/qcLrn+Kh9A=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-11-17";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "5312376077254d6431bb92ba22de3840b9933f67";
      hash = "sha256-uqbwwmWWz4NKseXiY0aey5w0e7gNSuWVTE31hQjtapc=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
