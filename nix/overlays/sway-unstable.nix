final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-04-26";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "82b4bc3f5f524edd90c7c9989084cbfdb02d90e8";
      hash = "sha256-G8fV+lO5sYw5/7Rq2mwuv05cL5bI6n5aZT5Rhku0kVA=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-04-23";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "646019cad9e8a075911e960fc7645471d9c26bf6";
      hash = "sha256-DeHPdl5JK9s9bOIEJF/rmD6Pb1tOAGoQDri+8nt7Nng=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots-unstable; };
}
