final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-06-05";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "385c9ade5f7a8ce9e5c13f762d56e6bd1c8d1b0a";
      hash = "sha256-kSBRbhuuBEAl9vD1Bucvth3b2TGVbQtVw9bMWO1Axk8=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-06-10";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "cc342107690631cf1ff003fed0b1cdb072491c63";
      hash = "sha256-RzPlJSWeMIKV6mZAcQMooERJmjYCogfGT/NPYlJM7yM=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
