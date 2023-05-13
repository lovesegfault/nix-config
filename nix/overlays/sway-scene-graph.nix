final: prev:
{
  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-04-16";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "10dd41669492f7582c26bd3989536a66278df75d";
      hash = "sha256-lYmvTWMNcD/1cU7x2CHjLtCtivsO2xz4E87YcPZg24s=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwerror=false" ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-04-16";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "01587db619375753cd925c0c2259b79c8a370f87";
      hash = "sha256-IC1zgvpDjdu5ND0gdpWA+uTMGTcU+UBqU+cnSjLU//M=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
