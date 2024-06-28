final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-06-27";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "85875c47d9234c2ad61bf3af97fca133fe3ffa78";
      hash = "sha256-w2mx2x9aQHgWv1PM5SWk7Qhb9rzBLpncMbCEPd2uKpk=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-06-27";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "cdde0165dad94e4522f8f6f040e9d30145fbb14f";
      hash = "sha256-xVkPZkrxFOB+cQAvkJCgfplaHAEp5Tv9M/Dj24Vh5Ys=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
