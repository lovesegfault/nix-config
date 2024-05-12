final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-05-11";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "56ebfde540da9631548773baba87beb716660322";
      hash = "sha256-rzhQnhWcCwhB4BurSQ1qO9DIWXCdByp9lL+pmFLwY/k=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-05-07";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "dcdb72757a5ec591c692df5e96c57c51758dbd8f";
      hash = "sha256-jONpgR398OZvzV1iYSoh63R2ob7dI1ZP0Tj+HCFclX4=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots-unstable; };
}
