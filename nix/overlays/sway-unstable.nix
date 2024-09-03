final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-09-02";
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
    version = "unstable-2024-09-02";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "be840f730e747a24106c8366ecb89e6b982cfa38";
      hash = "sha256-+sxX1U7MM1gPVEMwbWAbm2YD9dmm+o6k+GJlmls3kTM=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
